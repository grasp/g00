#!/usr/bin/ruby
require 'pathname'
require 'forever'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent #do we have one line solution?
#require File.join(project_root,"lib","tasks","grasp_init.rb")

Forever.run do
  dir File.expand_path('../', __FILE__) # Default is ../../__FILE__

  #before :all do
  #  puts "All jobs will will wait me for 1 second"; sleep 1
  #end

    every 1.day, :at => ['2:00'] do
   `cd ~`
   `rm -rf /home/hunter/dump`
    `mongodump -o /home/hunter/dump`
    `cp  /var/lib/redis/dump.rdb ~/dump`    
   `tar -xzvf daily_backup.tgz ~/dump`
    end

  on_error do |e|
    puts "Boom raised: #{e.message} #{Time.now}"
  end

  on_exit do
    puts "Bye bye on #{Time.now}"
  end
end

