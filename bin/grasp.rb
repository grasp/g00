#!/usr/bin/ruby

require 'rubygems' unless defined?(Gem)
require 'forever'
require 'yaml'
require 'pathname'
require 'mechanize'
require 'mongo'
require 'logger'
require 'mongoid'

pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent #do we have one line solution?
require File.join(project_root,"app","helpers","cities_helper.rb")


require File.join(project_root,"app","models","user.rb")
require File.join(project_root,"app","helpers","cargos_helper.rb")
require File.join(project_root,"app","helpers","quzhougrasp_helper.rb")
require File.join(project_root,"app","helpers","tf56grasp_helper.rb")
require File.join(project_root,"app","models","concerncityc.rb")
require File.join(project_root,"app","models","concernlinec.rb")
require File.join(project_root,"app","models","concernuserc.rb")
require File.join(project_root,"app","models","concernphonec.rb")
require File.join(project_root,"app","models","emaillistc.rb")
require File.join(project_root,"app","models","smslistc.rb")
require File.join(project_root,"app","models","cargo.rb")
require File.join(project_root,"app","models","truck.rb")
require File.join(project_root,"app","models","grasp_record.rb")
require File.join(project_root,"app","models","room_contact.rb")




require File.join(project_root,"config","initializers","init","city_dic.rb")
require File.join(project_root,"config","initializers","init","city_load.rb")
require File.join(project_root,"lib","tasks","mongoinit.rb")
require File.join(project_root,"lib","tasks","56qq.rb")
require File.join(project_root,"lib","tasks","56qq_helper.rb")
require File.join(project_root,"lib","tasks","56135.rb")
include QuzhougraspHelper
include Tf56graspHelper


Forever.run do
  dir File.expand_path('../', __FILE__) # Default is ../../__FILE__

  #before :all do
  #  puts "All jobs will will wait me for 1 second"; sleep 1
  #end

  every 2.minutes do
    hour=Time.now.hour
    if hour>5 and hour<23
    begin
      parse_56qq
    rescue
      puts $@
    end
    get_tf56_grasps
    end
  end
    
  every 3.minutes do
      hour=Time.now.hour
        if hour>5 and hour<23
    begin
      parse_56135
    rescue
      puts $@
    end
  
    begin
      get_quzhou_grasps
    rescue
      puts $@
    end
system("wget --spider http://w090.com/admin/dev_expire") #to expire city navi bar
system("wget --spider http://w090.com/cargos/allcity") #to regenerate city navi  cache
system("wget --spider http://w090.com/trucks/allcity") #to regenerate city navi  cache

        end
  end
  


  on_error do |e|
    puts "Boom raised: #{e.message} #{Time.now}"
  end

  on_exit do
    puts "Bye bye on #{Time.now}"
  end
end
if false

 parse_56qq
   get_tf56_grasps
    parse_56135
   get_quzhou_grasps
   end