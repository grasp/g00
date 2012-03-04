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
