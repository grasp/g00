# coding: utf-8 
## To change this template, choose Tools | Templates
# and open the template in the editor.
require 'iconv'
# require 'city_dic'
$KCODE="U"

# we take all city data as a global array of province
# each province is a :province_code  with value hash of region
#each region is a :city_code with value of hash of city

# when we found a new province, insert a new hash into citytree
# when we found a new region ,insert a new hash into province's hash
# when we found a city insert city hash into region's hash

# if search a city, we can easy get his province , thus we get all data under that hash

# at last ,frozen all array

# if mongodb has no city data , then insert it,is this needed?
# we need province name hash, and region name hash ,to get the actual name of code
#  {:province_id=>{:region_id1=>{{:city_id1,:city_name1},{:city_id2,:city2_name2}},{:region_id2=>{{:city_id,:city_name},{:city_id,:city_name}}}}
$citytree=Hash.new  # to store array of province hash
$province_region=Hash.new  # to store code with name pair for province and region
$city_name_code=Hash.new
$city_code_name=Hash.new
$province_tree=Hash.new #{province1=>[region1,region2,region3]}
$region_code=Hash.new #{"region_code"=>{city_code1,city_code2....}}

$all_region_hash=Hash.new #{region_name1=>code1,region_name2=>code2}
$all_province_hash=Hash.new #{province_name1=>code1,province_name2=>code2}
class CityTree  
  def initialize
    # @mongo = Connection.new
    #  @db = @mongo.db('g0')
    #  @col_city=@db[:city]

    puts "connection Mongodb success!" unless  @mongo.nil? ||@db.nil?
  end
  
  def process_to_level_4
    town_list=Hash.new
    count=0
    value1="（虚拟编码）".encode("GBK")
    value2="办事处".encode("GBK")
    value3="管理委员会".encode("GBK")
    value4=" ★".encode("GBK")

    exclude_value1="民政局".encode("GBK")
    exclude_value2="民政所".encode("GBK")
    exclude_value3="民政处".encode("GBK")

  
    open('code.txt').each do |line|
      name= line.split(',')
      if name[0].match(/\d+000000$/)
        name[1].delete!(value1) if name[1].match(value1)
        name[1].delete!(value2) if name[1].match(value2)
        name[1].delete!(value3) if name[1].match(value3)
        name[1].delete!(value4) if name[1].match(value4)
        name[1].strip!
      
        town_list[name[0]]=name[1]+"\n"  if not (name[1].match(exclude_value1) ||
            name[1].match(exclude_value2) ||
            name[1].match(exclude_value3) )
        # name[1].size <6 )
        count+=1
      end
    end

    out = File.new("code2.txt","w")
    town_list.each do |key,value|
      out << "#{key},#{value}"
    end
    out.close
    puts "结束城市基础数据文本的第一次加工处理"
  end

  #$citytree
  #  {:province_id=>{:region_id1=>{{:city_id1,:city_name1},{:city_id2,:city2_name2}},{:region_id2=>{{:city_id,:city_name},{:city_id,:city_name}}}}
  def parse_code_text3
    #first write into all province name
    filename=File.dirname(__FILE__)+File::SEPARATOR+"code3.txt"
    open(filename).each do |line|
      line=Iconv.conv("utf-8//IGNORE","GB2312",line)
      name= line.split(',')
      name[1]=name[1].chomp!
      $city_name_code[name[1]]=name[0]
      $city_code_name[name[0]]=name[1]
      if name[0].match(/\d\d0000000000$/) # is a province id
        $province_region[name[0]]=name[1]  #insert name hash at first when found a province
        $citytree[name[0]]={}
        $province_tree[name[0]]=Array.new
        
       
      elsif name[0].match(/\d\d\d\d00000000$/)  and (not name[0].match(/\d\d0000000000$/))  # is a region
        $province_region[name[0]]=name[1]  #insert name hash at first when found a region
        province_code=name[0].slice(0,2)+"0000000000"
        $citytree[province_code][name[0]]={}
        $province_tree[province_code]=$province_tree[province_code]<<name[0]
        $all_region_hash[name[1]]=name[0]

        $region_code[name[0]]=[]
        # puts "is region =#{name[1]}"

      
      elsif (not name[0].match(/\d\d\d\d00000000$/)) and (not name[0].match(/\d\d0000000000$/))# is a city
        province_code=name[0].slice(0,2)+"0000000000"
        region_code=name[0].slice(0,4)+"00000000"
        $citytree[province_code][region_code][name[0]]=name[1]
        $region_code[region_code]<<name[0]
        # puts "is city =#{name[1]}"
      
      else
        puts "非法城市数据"
      end
      
     
    end
  end

  def print_city_tree
    #  puts "print province"
    puts Time.now
    start_time=Time.now
    $citytree.each do |key,value|
      #puts "province#{key}=#{$province_region[key]}"
    end
  
    puts "print region"
    $citytree.each do |province_code,region|
      region.each do |region_code,city|
        # puts "region#{region_code}=#{$province_region[region_code]}"
      end
    end
  
    puts "print city"
    $citytree.each do |province_code,region|
      region.each do |region_code,city|
        city.each do |city_code,city_name|
          #    puts "city #{city_code}=#{city_name}"
        end
      end
    end
    end_time=Time.now
    puts Time.now
    puts "cost time pase all#{end_time-start_time}"
  end


  def self.get_city_full_path(code)
    #puts "start get full path of code =#{code}"
    unless code.nil?
      if code.match(/\d\d0000000000$/) # is a province id
        return $city_code_name[code]
      elsif code.match(/\d\d\d\d00000000$/)  and (not code.match(/\d\d0000000000$/))  # is a region
        province_code=code.slice(0,2)+"0000000000"
        return $city_code_name[province_code]+$city_code_name[code]
      elsif (not code.match(/\d\d\d\d00000000$/)) and (not code.match(/\d\d0000000000$/))# is a city
        province_code=code.slice(0,2)+"0000000000"
        region_code=code.slice(0,4)+"00000000"
        # puts "$city_code_name[province_code]=#{$city_code_name[province_code]}"
        #  puts "$city_code_name[region_code]=#{$city_code_name[region_code]}"
        # puts "$city_code_name[code] =#{$city_code_name[code]}"
        return $city_code_name[province_code]+$city_code_name[region_code]+$city_code_name[code]
      else
        return nil
      end
    end
  end
  
#this is important function 
  def self.get_code_from_name(from_name)
    
    name=from_name.gsub("不限","")
    #first lookup into city_dic
   # return  $city_dic[name] unless $city_dic[name].nil?
    #  log = Logger.new("56135.log")
     # log.info("guess array")

    guess_array=[$city_name[name]|| name]
    
    name.size.downto(2).each do |i|
      guess_array<<name[-i,i] #from last
    #  log.info "#{i}guess"+name[-i,i]
    end

    guess_array.each do |guess|
      city_name=[guess,guess+"省",guess+"市",guess+"县",guess+"区"]
      city_name.each do |c|
      #  $city_dic[name]=$city_name_code[c];
       unless $city_name_code[c].nil?
       #  log.info "1get #{c}"
        return $city_name_code[c]
       end
      end
    end
    
  #if we cant get last city, try to match region name, return region
  $all_region_hash.each do |cname,code|
    if name.match(cname)
      return code
    end
  end
    
    $all_province_hash.each do |cname,code|
    if name.match(cname)
      return code
    end
  end
    #still not guess out? then we guess from first
    guess2=Array.new
    if name.size>1 
      2.downto(0).each do |i|
        guess2<<name[0,i] #from forward
      end
      guess2.each do |guess|       
        city_name=[guess,guess+"省",guess+"市",guess+"县",guess+"区"]    
        city_name.each do |c|
         # $city_dic[name]=$city_name_code[c]; 
         unless $city_name_code[c].nil?
           #  log.info "2get #{c}"
          return $city_name_code[c] 
         end
        end
      end
    end
    
    return nil
  end


  # generate a province hash for list
  #$province["100000000000"]="全国"

  $raw_province_array=
    [[110000000000,130000000000,210000000000,220000000000,320000000000,330000000000,350000000000,370000000000,420000000000,440000000000,460000000000,510000000000,530000000000,610000000000,150000000000],
    [120000000000,140000000000,310000000000,340000000000,360000000000,410000000000,430000000000,450000000000,500000000000,520000000000,540000000000,620000000000,630000000000,650000000000,230000000000,]]
end
$sequnced_province=[110000000000,120000000000,130000000000,310000000000,320000000000,330000000000,210000000000,220000000000,230000000000,
  440000000000,  450000000000,  350000000000,460000000000,
  370000000000,140000000000,
  420000000000,   430000000000,
  410000000000,
  360000000000,340000000000,
  500000000000,510000000000,520000000000,530000000000,540000000000,610000000000,150000000000,
  620000000000,630000000000,650000000000]

#do not parse everty time ,only once can be ok,but for cron,it have to parse again??
def parse_city_text
  CityTree.new.parse_code_text3
  $citytree.freeze
  $province_region.freeze
  $city_name_code.freeze
  $city_code_name.freeze
end

parse_city_text





