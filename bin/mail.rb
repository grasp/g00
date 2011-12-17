#!/usr/bin/ruby

require 'rubygems' unless defined?(Gem)
require 'forever'
require 'yaml'

Forever.run do
  dir File.expand_path('../', __FILE__) # Default is ../../__FILE__

  before :all do
    puts "All jobs will will wait me for 1 second"; sleep 1
  end

  every 10.seconds, :at => "#{Time.now.hour}:00" do
    puts "Every 10 seconds but first call at #{Time.now.hour}:00"
  end

  every 1.seconds, :at => "#{Time.now.hour}:#{Time.now.min+1}" do
    puts "Every one second but first call at #{Time.now.hour}:#{Time.now.min}"
  end

  every 10.seconds do
    puts "Every 10 second"
  end

  every 20.seconds do
    puts "Every 20 second"
  end

  every 15.seconds do
    puts "Every 15 seconds, but my task require 10 seconds"; sleep 10
    # This doesn't block other jobs and your queue !!!!!!!
  end

  every 10.seconds, :at => [":#{Time.now.min+1}", ":#{Time.now.min+2}"] do
    puts "Every 10 seconds but first call at xx:#{Time.now.min}"
  end

  on_error do |e|
    puts "Boom raised: #{e.message}"
  end

  on_exit do
    puts "Bye bye"
  end
end