#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'rubygems'
require 'logger'
require 'pathname'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?
require File.join(project_root,"config","initializers","init","city_load.rb")
require File.join(project_root,"config","initializers","init","city_dic.rb")


def guess_line(line)
   log = Logger.new("56qq.log")
   #log.info line
   city_from_code=CityTree.get_code_from_name(line[0]) 
   city_to_code=CityTree.get_code_from_name(line[1]) 
  return [city_from_code,city_to_code] 
end
def parse_56qq_line(line)
  #log = Logger.new("56qq.log")
  #log.info "start to parse #{line}"
  all_line=Array.new
  #first strip []
  raw_line=line.gsub(/\[|\]/,"")
 # log.info raw_line
  city_from=raw_line.split("-")[0]
  #log.info  city_from
  city_to=raw_line.split("-")[1].split(",")
 # log.info  city_to
  city_to.each do |tocity|
    all_line<<[city_from,tocity]
  end
 # convert all line to city code
 city_code_line=Array.new
 all_line.each do |line|
   city_code_line<<guess_line(line)
 end
 
 return city_code_line
end



 
  def parse_telephone
    
  end

#parse_56qq_line("[漯河-石家庄,运城,三门峡,阜阳]").each do |line|
 # guess_line(line)
#end