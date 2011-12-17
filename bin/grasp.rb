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
project_root=pn.parent.parent #do we have one line solution?
puts "project_root=#{project_root}"
require File.join(project_root,"app","helpers","cities_helper.rb")
require File.join(project_root,"app","helpers","quzhougrasp_helper.rb")
require File.join(project_root,"app","helpers","tf56grasp_helper.rb")

require File.join(project_root,"app","models","user.rb")
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

  every 2.minutes, :at => "#{Time.now.hour}:00" do
    begin
      parse_56qq
    rescue
      puts $@
    end
    get_tf56_grasps
  end
    
  every 3.minutes, :at => "#{Time.now.hour}:00" do
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

  end
  


  on_error do |e|
    puts "Boom raised: #{e.message} #{Time.now}"
  end

  on_exit do
    puts "Bye bye on #{Time.now}"
  end
end