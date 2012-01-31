#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'rubygems'
require 'roo'
require 'pathname'
require 'mongoid'
require 'geocoder'
require 'redis'
require 'redis-store'
require 'mongoid'

pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?
require File.join(project_root,"config","initializers","init","geo_init.rb")
require File.join(project_root,"config","initializers","init","city_dic.rb")
require File.join(project_root,"config","initializers","init","city_load.rb")
require File.join(project_root,"app","helpers","cities_helper.rb")
require File.join(project_root,"lib","tasks","mongoinit.rb")
require File.join(project_root,"app","models","city.rb")
include CitiesHelper

logger=Logger.new("city_location_parse.log")
#if false
s = Excel.new("city_location.xls") 
   nilcounter=0
   citycounter=0
   parseerror=0
   left_counter=0
   parsed_city=Hash.new
   parsed_lat=Hash.new
   parsed_lng=Hash.new
s.sheets.each do |sheet|
 unless sheet.to_s.match("查询")
  logger.info sheet  
 s.default_sheet=sheet
 province_code=CityTree.get_code_from_name(sheet.to_s)
  s.last_row.downto(s.first_row).each do| row_index|
    city_name=s.cell(row_index,1)    
   # logger.info city_name+" "+s.cell(row_index,2).to_s+" "+s.cell(row_index,3).to_s     
 
  citycode=CityTree.get_code_from_name( city_name )
  
 if citycode.nil?
   nilcounter+=1
    logger.info " city_name=#{ city_name},city_counter=#{citycounter},nilcounter=#{ nilcounter}"
 else
   citycounter+=1
   unless province_code.nil?
   if citycode[0,2]!=province_code[0,2]  #must be in province code
     parseerror+=1
      logger.info " parse error city_name=#{ city_name},city_counter=#{citycounter},nilcounter=#{ nilcounter},#{citycode},#{province_code}"
   else
     parsed_city[citycode]=city_name
     parsed_lat[citycode]=s.cell(row_index,2) 
     parsed_lng[citycode]=s.cell(row_index,3) 
   end
   end
  end
end
end
   logger.info "city_counter #{citycounter},nilcounter=#{ nilcounter},parseerror=#{parseerror}"
end

$city_code_name.each do |code,name|
      #insert lat and lng into city
  city=City.where(:code=>code).first
  if city.lat.nil? || city.lng.nil?
  if parsed_city[code].nil?
  left_counter+=1  
  logger.info " #{name}#{code}parse #{get_city_full_name_for_location_search(code)} from google start"
  begin
  location=Geocoder.coordinates(get_city_full_name_for_location_search(code))
     city.update_attributes(:lat=>location[1].to_s,:lng=>location[0].to_s) unless location.nil?
  rescue
    logger.info " #{name}#{code}parse error!!!"
  end
  #  logger.info "parse #{name} from google done"
  else

   # city.delete    
   # City.create(:code=>code,:name=>name,:lat=>parsed_lat[code],:lng=>parsed_lng[code])
  city.update_attributes(:lat=>parsed_lat[code],:lng=>parsed_lng[code])
   # logger.info " update city_code=#{ code},:lat=#{parsed_lat[code]},:lng=#{ parsed_lng[code]}"
  end
end
end
logger.info "left counter=#{left_counter}"
#end
#logger.info get_city_full_name_for_location_search("120104000000").encoding.name
#logger.info Geocoder.coordinates(get_city_full_name_for_location_search("120104000000"))