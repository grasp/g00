#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

def parse_56135

  @admin=User.where("name"=>"admin").first
  # log = Logger.new("56135.log")
  agent = Mechanize.new  
  agent.cookie_jar.load_cookiestxt(StringIO.new($cookie))  
  agent.user_agent_alias = 'Windows Mozilla'
  #agent.set_proxy("wwwgate0-ch.mot.com", 1080)  if true
  
  #analysis page now
  page_raw_array=Array.new
  
  agent.get("http://www.56135.com/56135/trade/tradeindex///1.html") do |page|
    page.parser.css("div.info_show").each do |entrycontainer|
      raw_array=Array.new
     
      lininfo=entrycontainer.css("div.area").text.to_s
      from_name= lininfo.to_s.match(/起运地.*目的地/u).to_s
      to_name= lininfo.to_s.gsub(from_name,"").gsub("：","").gsub("-","").gsub("  ","").to_s
      from_name=from_name.gsub("起运地","").gsub("目的地","").gsub("：","").gsub("-","").gsub("  ","").to_s
      #  log.info "from=#{from_name},to=#{to_name}"
      # log.info "from=#{CityTree.get_code_from_name(from_name)},to=#{CityTree.get_code_from_name(to_name)},"
      raw_array[1]=from_name;raw_array[2]=to_name;
    
      packinfo=entrycontainer.css("div.c_line").text.match(/货品属性.*$/u).to_s
      raw_array[0]= packinfo.match(/货品属性：.*重量：/u).to_s.gsub("货品属性：","").gsub("重量：","").to_s
      
      raw_array[3]= packinfo.match(/重量：.* 吨/u).to_s.gsub("重量：","").gsub("吨","").to_s
      # log.info raw_array[0]
      #  log.info raw_array[3]

      #other information
      raw_array[5]= entrycontainer.css("div.c_name").text.match(/^.*交易状态/u).to_s.gsub("交易状态","").to_s
      #  raw_array[6]= entrycontainer.css("div.c_main_r").text.match(/^.*竞\s标\s数/u).to_s.gsub(/竞\s标\s数/,"").to_s
      raw_array[6]= entrycontainer.css("div.c_main_r").text
      raw_array[7] =entrycontainer.css("div.c_btm").text.to_s
         
      page_raw_array<<raw_array
    end
  end

  #log.info(page_raw_array)

  # put the page_raw_array into our bag

  page_raw_array.each do |raw_array|
    cargo=Cargo.new
    cargo[:fcity_code]=CityTree.get_code_from_name(raw_array[1])
    cargo[:tcity_code]=CityTree.get_code_from_name(raw_array[2])
    if !cargo[:fcity_code].nil? && !cargo[:tcity_code].nil?
      cargo[:line]=cargo[:fcity_code]+"#"+cargo[:tcity_code]
      cargo[:fcity_name]=CityTree.get_city_full_path(cargo[:fcity_code])
      cargo[:tcity_name]=CityTree.get_city_full_path(cargo[:tcity_code])  
      cargo[:comments]=raw_array[5].to_s+raw_array[6].to_s+raw_array[7].to_s
      
      cargo[:mobilephone]=cargo[:comments].match(/1\d\d\d\d\d\d\d\d\d\d/).to_s
      cargo[:fixphone]=cargo[:comments].match(/\d\d\d+-\d\d\d\d\d\d\d+/).to_s  
      #   log.info   cargo[:comments]
      cargo[:cargo_weight]=raw_array[3]
      cargo[:cate_name]=raw_array[5]
      cargo[:send_date]=1
      cargo[:from_site]="56135"
      cargo[:created_at]=Time.now
      cargo[:status]="正在配车"  # for match local
      cargo[:priority]=500
      cargo[:user_id]=@admin.id unless @admin.nil?
      #  log.info cargo
      begin
       a=cargo.save!
       if a
         @cargo=a
         notify
       end
      rescue Exception 
        # log.info $@
      end
    end
    # end    
  end
end

#begin
#parse_56135
#puts "parse done"
#rescue
#puts $@
#  puts "excetion to parse 56135"
#end


