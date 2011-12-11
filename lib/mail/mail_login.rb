#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
#if false
ENV["RAILS_ENV"] = "test"
#require  File.dirname(__FILE__) + "/../test_helper.rb"
start_time=Time.now
require 'watir'
require  'rubygems'
require 'active_support/all'
#require 'test/unit/notify'
require "test/unit"
puts "load test env cost #{Time.now-start_time} sec"
#end
16.downto(1).each do |i|
  if i!=6
 
  browser =Watir::IE.new
  browser.speed = :fast
 # $browser.minimize
  $site_root= "http://mail.google.com/"
  browser.goto($site_root)
  browser.text_field(:id, "Email").set("w090."+ "%03d" % i)
  browser.text_field(:id, "Passwd").set("11102008")
  browser.button(:id, "signIn").click;
 sleep(1)
 #$browser.link(:id, ":qy").click;
 #$browser.close
  end
end