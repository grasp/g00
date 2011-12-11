#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.


require  'rubygems'
require 'watir'
puts "Hello World"
#require 'active_support/all'
#require 'test/unit/notify'
#require "test/unit"

#key word 物流专线qq,
#物流有限公司 qq 
#物流 竭诚为你服务   qq,
#物流  欢迎来电    qq
def search_google_qq(keyword)
  
@browser = Watir::IE.new
@browser.goto 'www.google.com.hk';@browser.wait;sleep 2
#@browser.minimize #must comments 
#fill the key words
@browser.text_field(:id, "lst-ib").set(keyword);@browser.wait;sleep 2
#click search button
@browser.button(:name,"btnG").click;@browser.wait;sleep 2

begin
1.upto(100).each do |i|
puts " scan page #{i} \n"
@browser.div(:id,"navcnt").link(:url, Regexp.new(Regexp.escape("&start=#{10*i}&"))).click
#puts @browser.text.scan(/(q|Q)\D{0,10}\d{5,10}/ixmuo)
puts @browser.text.scan(/([qQ][qQ].{0,10}\d{5,10}[\s|\n|\b\|\B])/ou)
@browser.wait;sleep 1
end
rescue  
  puts $@
end
end

search_google_qq("物流专线 qq")