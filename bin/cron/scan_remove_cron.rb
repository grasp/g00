#!/usr/bin/ruby
require 'pathname'
require 'forever'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?
require File.join(project_root,"lib","tasks","grasp_init.rb")

Forever.run do
  dir File.expand_path('../', __FILE__) # Default is ../../__FILE__
  #before :all do
  #  puts "All jobs will will wait me for 1 second"; sleep 1
  #end
if false
  every 2.minutes do
    hour=Time.now.hour
    if hour>5 and hour<23
      begin
        parse_56qq
        get_tf56_grasps
      rescue
        puts $@
      end 
    end
  end
    
  every 3.minutes do
    hour=Time.now.hour
    if hour>5 and hour<23
      begin
       # parse_56135
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
  every 20.minutes do
    hour=Time.now.hour
    if hour>5 and hour<23          
      parse_haoyun56    
    end
  end
end
  every 2.day, :at => ['2:30'] do
    scan_move
  end
  
    every 1.day, :at => ['1:30'] do
    Ustatistic.all.each do |ustatistic|
     ustatistic.update_attribute(:todaymail,0)
    end
     Sitedatum.first.update_attribute(:msent,0)
     Sitedatum.first.update_attributes(:ie6=>0,:ie7=>0,:ie8=>0,:noneie=>0,:loginuser=>0,:spider=>1)
  end
  

  on_error do |e|
    puts "Boom raised: #{e.message} #{Time.now}"
  end

  on_exit do
    puts "Bye bye on #{Time.now}"
  end
end
