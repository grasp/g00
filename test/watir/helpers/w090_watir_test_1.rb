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
require "test/unit"
puts "load test env cost #{Time.now-start_time} sec"
#end


class ActiveSupport::TestCase

  
  
  $browser =Watir::IE.new
  $browser.speed = :fast
  $browser.minimize
  $site_root= "http://localhost:4500"  
  
  $user_name1=Time.now.to_s.gsub(/\s|:|\+/,"").to_s 
  $user_email1="#{$user_name1}@gmail.com"
  $mobile_phone1=$user_name1.slice(9,18)
  $paizhao1=$mobile_phone1.slice(0,6)
  
  sleep 2
  $user_name2=Time.now.to_s.gsub(/\s|:|\+/,"").to_s 
  $user_email2="#{$user_name2}@gmail.com"
  $mobile_phone2=$user_name2.slice(9,18)
  $paizhao2=$mobile_phone2.slice(0,6)

  $browser.goto("#{$site_root}")
  $browser.link(:href, "#{$site_root}/users/new").click
  $browser.text_field(:id, "user_name").set($user_name1)
  $browser.text_field(:id, "user_email").set($user_email1)
  $browser.text_field(:id, "user_password").set("1234567")
  $browser.text_field(:id, "user_password_confirmation").set("1234567")
  $browser.text_field(:id, "user_mobilephone").set($mobile_phone1)
  $browser.button(:id, "user_submit").click;sleep 0.5
   if $browser.text.match("登出")
      $browser.link(:text, "登出").click;sleep 1
   end
   
   $browser.goto("#{$site_root}")
  $browser.link(:href, "#{$site_root}/users/new").click
  $browser.text_field(:id, "user_name").set($user_name2)
  $browser.text_field(:id, "user_email").set($user_email2)
  $browser.text_field(:id, "user_password").set("1234567")
  $browser.text_field(:id, "user_password_confirmation").set("1234567")
  $browser.text_field(:id, "user_mobilephone").set($mobile_phone2)
  $browser.button(:id, "user_submit").click;sleep 0.5
   if $browser.text.match("登出")
      $browser.link(:text, "登出").click;sleep 1
   end
# end  
  def logout_and_login(username)
    logout
    login(username)
  end
  
  def logout
     if $browser.text.match("登出")
      $browser.link(:text, "登出").click;sleep 1
    else
      $browser.goto("#{$site_root}");sleep 1
    end
  end
  
  def login(username)
   assert $browser.link(:href, "#{$site_root}/users/login").click;sleep 1
    result=$browser.text.force_encoding('utf-8')
    ["欢迎来到物流零距离","用户登录","密码","用户名或Email"].each { |text| assert result.include?(text),"#{text} 不存在 !!"}
    $browser.text_field(:id, "email").set(username)
    $browser.text_field(:id, "password").set("1234567")
    $browser.button(:value, "登录").click
  end

  def line_select(from_province,from_city,to_province,to_city)
     assert $browser.link(:id, "from_data_load").click;sleep 0.8
    ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
     assert $browser.link(:text, "#{from_province}").click;sleep 0.8
     ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     
      assert $browser.link(:text, "#{from_city}").click;sleep 0.8
     ["#{from_province}","#{from_city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:id, "from_data_load").click;sleep 0.8
     ["#{from_province}","#{from_city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    
    assert $browser.link(:id, "to_data_load").click;sleep 0.8
    ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
     assert $browser.link(:text, "#{to_province}").click;sleep 0.8
     ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     
      assert $browser.link(:text, "#{to_city}").click;sleep 0.8
     ["#{to_province}","#{to_city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:id, "to_data_load").click;sleep 0.8
     ["#{to_province}","#{to_city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
  end
  
end


