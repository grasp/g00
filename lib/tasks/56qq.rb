#coding:utf-8
require 'pathname'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?
#puts "project_root=#{project_root}"
require File.join(project_root,"lib","tasks","grasp_init.rb")

def parse_56qq    
 # cookie=load_cookie #get all the cookies
  @admin=User.where("name"=>"admin").first
  log = Logger.new("56qq.log")
 # log.level = Logger::WARN
  log.level = Logger::INFO
  agent = Mechanize.new  
  agent.cookie_jar.load_cookiestxt(StringIO.new($cookie))  
  
  agent.user_agent_alias = 'Windows Mozilla'
  #agent.set_proxy("wwwgate0-ch.mot.com", 1080)  if true
  
  #analysis page now
  page_raw_array=Array.new
  agent.get("http://www.56qq.cn/#msgboard/list/all") do |page|
    page.parser.css("div.entry").each do |entrycontainer|
      page_raw_array<<[ entrycontainer.css("span.entry_city").text.strip.gsub(/\r\n/,"")  ,
        entrycontainer.css("span.spanentry_text").text.strip.gsub(/\r\n/,"") ,
        entrycontainer.css("span.cred").text.strip.gsub(/\r\n/,"")  
      ]
    end
  end
  
  #expand to flat line
  cargolist=Array.new
  trucklist=Array.new
  page_raw_array.each do |raw_array|
    line_info=raw_array[0]   
    parse_56qq_line(line_info).each do |line|
     # log.info  line
      if raw_array[1].match("货源信息")
        cargolist<<[line,raw_array[1], raw_array[2]]
      end
      
      if raw_array[1].match("车源信息")
        trucklist<<[line,raw_array[1], raw_array[2]]
      end
    end    
  end
  # puts "cargolist.count=#{cargolist.size}"
  # log.info   cargolist
  # log.info   trucklist
  
  #now save to database, seemed it is easy to do
  cargolist.each do |onecargo|
    if !onecargo[0][0].nil? and !onecargo[0][1].nil?
      cargo=Cargo.new  
      cargo[:fcity_code]=onecargo[0][0]
      cargo[:tcity_code]=onecargo[0][1]
    #  puts "#{ cargo[:fcity_code]}-->#{ cargo[:tcity_code]}"
      cargo[:line]=cargo[:fcity_code]+"#"+cargo[:tcity_code]
      cargo[:fcity_name]=CityTree.get_city_full_path(cargo[:fcity_code])
      cargo[:tcity_name]=CityTree.get_city_full_path(cargo[:tcity_code])  
    
      cargo[:comments]=onecargo[1].gsub(/货源信息：/,"").gsub(/备注内容：/,"").gsub(/联系我时，请说是在56QQ上看到的，谢谢！/,"").gsub(/\s/,"")
      cargo[:cargo_weight]=onecargo[1].match(/\d\d\d吨|\d\d吨|\d吨|\d方|\d\d方/).to_s
      cargo[:cate_name]=cargo[:comments].to_s[-10..-1]

      cargo[:contact]=onecargo[2].gsub(/TEL\:/,"")
      
      #fetch mobilephone and fixphone
      cargo[:mobilephone]=cargo[:contact].match(/1\d\d\d\d\d\d\d\d\d\d/).to_s
      cargo[:fixphone]=cargo[:contact].match(/\d\d\d+-\d\d\d\d\d\d\d+/).to_s  
      cargo[:send_date]=1
      cargo[:from_site]="56qq"
      cargo[:created_at]=Time.now
      cargo[:status]="正在配车"  # for match local
      cargo[:priority]=300
      cargo[:user_id]=@admin.id unless @admin.nil?
     #log.info cargo
      begin
       a=cargo.save
      rescue Exception 
        log.info $@
      end
      
      begin
       if a
         @cargo=a
         notify
       end
      rescue Exception 
      #  log.info $@
      end
    end
  end
  
  trucklist.each do |onetruck|
    if !onetruck[0][0].nil? and !onetruck[0][1].nil?
      truck=Truck.new  
      truck[:fcity_code]=onetruck[0][0]
      truck[:tcity_code]=onetruck[0][1]
      truck[:fcity_name]=CityTree.get_city_full_path(truck[:fcity_code])
      truck[:tcity_name]=CityTree.get_city_full_path(truck[:tcity_code])  
    
      truck[:comments]=onetruck[1].gsub(/车源信息：/,"").gsub(/备注内容：/,"").gsub(/联系我时，请说是在56QQ上看到的，谢谢！/,"").gsub(/\s/,"")
      truck[:length]=onetruck[1].match(/\d\d\d米|\d\d米|\d米|\d\.\d米|\d\d\.\d米/).to_s      
      truck[:paizhao]=truck[:comments].to_s[-10..-1]      
      truck[:contact]=onetruck[2].gsub(/TEL\:/,"")
      truck[:send_date]=1
      truck[:from_site]="56qq"
      truck[:created_at]=Time.now
      truck[:status]="正在配货"  # for match local
      truck[:priority]=300
      truck[:user_id]=@admin.id unless @admin.nil?
      #log.info truck
      begin
        truck.save!
      rescue Exception 
       log.info $@
      end

    end
  end
  
end

#parse_56qq
