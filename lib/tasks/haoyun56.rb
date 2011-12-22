#coding:utf-8



def parse_haoyun56    
  
  @admin=User.where("name"=>"admin").first
  log = Logger.new("haoyun56.log")
  agent = Mechanize.new  
  agent.cookie_jar.load_cookiestxt(StringIO.new($cookie))  
  
  agent.user_agent_alias = 'Windows Mozilla'
#  agent.set_proxy("wwwgate0-ch.mot.com", 1080)  if true
  
  #analysis page now
  page_raw_array=Array.new
  agent.get("http://peihuo.haoyun56.com/goods/") do |page|
    page.parser.css("tr.list_list").each do |entrycontainer|
      raw_array=Array.new
       entrycontainer.css("td").each do |entrytd|
       raw_array<<entrytd.text.gsub(/\r\n/,"").gsub(/\s/,"")         
       end
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
   cargo[:fcity_name]=CityTree.get_city_full_path(cargo[:fcity_code])
   cargo[:tcity_name]=CityTree.get_city_full_path(cargo[:tcity_code])  
   
      cargo[:comments]=raw_array[1]+"->"+raw_array[2]+raw_array[5]+","+raw_array[6]+","+raw_array[4]+"发布时间"+raw_array[7]
      cargo[:cargo_weight]=raw_array[3]
      cargo[:cate_name]=raw_array[0]+","+raw_array[5].to_s[0..12]
      cargo[:send_date]=1
      cargo[:from_site]="haoyun56"
      cargo[:created_at]=Time.now
      cargo[:status]="正在配车"  # for match local
      cargo[:priority]=400
      cargo[:user_id]=@admin.id unless @admin.nil?
  #  log.info cargo
      begin
        cargo.save!
      rescue Exception 
     # log.info $@
      end
   end
   # end    
  end
  
end
begin
parse_haoyun56
rescue
puts $@
  puts "excetion to parse haoyun56!"
end
