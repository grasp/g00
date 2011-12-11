#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
start_time=Time.now
require 'watir'
require  'rubygems'
require 'active_support/all'
require "test/unit"
puts "load test env cost #{Time.now-start_time} sec"



class ActiveSupport::TestCase

  $browser =Watir::IE.new
  $browser.speed = :fast
#  $browser.minimize
  $site_root= "http://exmail.qq.com" 

   
  def login(username,password)
    puts "test login"
    $browser.goto("http://exmail.qq.com/login")    
    $browser.text_field(:name, "inputuin").set(username)
    $browser.text_field(:name, "pp").set(password)
    $browser.button(:id, "btlogin").click;sleep 2    
  end
  
  
  def add_new_user(username,password,mail_account)     
     $browser.link(:url, Regexp.new(Regexp.escape("#mbr/account/add"))).click;sleep 2 
     $browser.text_field(:name,"name").set(username)
     $browser.text_field(:name,"alias").set(mail_account)
     $browser.text_field(:name,"passwd").set(password)
     $browser.text_field(:name,"passwd2").set(password)
      $browser.checkbox(:name, "物流零距离").set
     $browser.button(:value, "确定").click;sleep 7
     ["物流零距离","wl090.com"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}

  end
 
  def login_and_add_new_user
  # $browser.goto($site_root)
   # username="w090.master"
   # password="followme123#"
  #  login(username,password);sleep 2
  
      $browser =Watir::IE.new
  $browser.speed = :fast
#  $browser.minimize
  $site_root= "http://exmail.qq.com" 
  $browser.goto("http://exmail.qq.com")
    sleep 40
    $browser.link(:text, "成员帐号").click;sleep 2
      4.downto(1).each do |i|
      username="物流零距离-"+"%03d" % i
      password="followme123#"
      mail_account="w090_"+"%03d" % i
      add_new_user(username,password,mail_account)
  
    end 

   
  end
  
  
  def test_login_and_change_password_for_each_account
    $browser.goto("http://exmail.qq.com/login")
    198.downto(1).each do |i|
      username="w090_"+"%03d" % i+"@wl090.com"
      password="followme123#"
      
    $browser.text_field(:name, "inputuin").set(username)
    $browser.text_field(:name, "pp").set(password)
    $browser.button(:id, "btlogin").click;sleep 2
      $browser.goto("http://exmail.qq.com/login");
      
      sleep 15
    end
  end 
  
end
