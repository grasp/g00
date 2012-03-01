#coding:utf-8

ENV["RAILS_ENV"] = "test"
#require  File.dirname(__FILE__) + "/../test_helper.rb"
start_time=Time.now
require 'watir'
require  'rubygems'
require 'active_support/all'
require "test/unit"
require 'watir/close_all'  

puts "load test env cost #{Time.now-start_time} sec"

def prepare_watir
  Watir::IE.close_all  
  @browser =Watir::IE.new
  @browser.speed = :fast
  # @browser.minimize
  @site_root= "http://localhost:4500"  
  @browser.goto(@site_root)
  user_logout(@browser) #make sure user is logout
end

def define_user_1
  @user_name1=Time.now.to_s.gsub(/\s|:|\+/,"").to_s 
  @user_email1="#{@user_name1}@gmail.com"
  @mobile_phone1=@user_name1.slice(9,18)
  @paizhao1=@mobile_phone1.slice(0,6)
end

def define_user_2
  @user_name2=Time.now.to_s.gsub(/\s|:|\+/,"").to_s 
  @user_email2="#{@user_name2}@gmail.com"
  @mobile_phone2=@user_name2.slice(9,18)
  @paizhao2=@mobile_phone2.slice(0,6)
end
def user_logout(browser)
  if browser.text.match("退出")
    browser.link(:text, "退出").click;sleep 1
  end
  sleep 1
  ["登录"].each { |text|  assert browser.text.include?(text),"#{text} 不存在 !!"} 
end

def user_login(browser,site_root,username,password)
  
  browser.goto("#{site_root}/users/login")
  browser.text_field(:id, "email").set(username)
  browser.text_field(:id, "password").set(password)
  browser.button(:value, "登  录").click;sleep 0.5
   ["退出",username].each { |text|  assert browser.text.include?(text),"#{text} 不存在 !!"} 
end



def user_logout_login(browser,site_root,username,password)
 user_logout(browser)
 user_login(browser,site_root,username,password)
end

def line_select(browser,from_province,from_city,to_province,to_city)
  assert browser.link(:id, "from_data_load").click;sleep 0.8;  ["浙江","上海","北京","西藏"].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}    
  assert browser.link(:text, "#{from_province}").click;sleep 0.8;  ["浙江","上海","北京","西藏"].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}        
  assert browser.link(:text, "#{from_city}").click;sleep 0.8; ["#{from_province}","#{from_city}"].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}    
  assert browser.link(:id, "from_data_load").click;sleep 0.8;     ["#{from_province}","#{from_city}"].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}     
  assert browser.link(:id, "to_data_load").click;sleep 0.8;    ["浙江","上海","北京","西藏"].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}    
  assert browser.link(:text, "#{to_province}").click;sleep 0.8;     ["浙江","上海","北京","西藏"].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}     
  assert browser.link(:text, "#{to_city}").click;sleep 0.8;     ["#{to_province}","#{to_city}"].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}    
  assert browser.link(:id, "to_data_load").click;sleep 0.8;     ["#{to_province}","#{to_city}"].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}    
end
