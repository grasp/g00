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
# $browser.minimize
  $site_root= "http://ym.163.com/" 

   
  def login(username,password)
    puts "test login"
    $browser.text_field(:name, "userAtDomain").set(username)
    $browser.text_field(:name, "password").set(password)
    $browser.button(:text, "登 录").click;sleep 3     
  end
  
  def add_new_user(username,password,mail_account)
     $browser.link(:text, "成员管理").click;sleep 1
     $browser.link(:text, "添加成员").click;sleep 1 
     $browser.text_field(:id,"nickname").set(username)
     $browser.text_field(:id,"account_name").set(mail_account)
     $browser.text_field(:id,"pass_re").set(password)
     $browser.span(:text, "添加完成").click;sleep 1 
     ["添加成功","返回成员管理"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     $browser.link(:text,"<<返回成员管理").click;sleep 1
  end
 
  def login_and_add_new_user
    $browser.goto($site_root)
    username="w090.master@w090.com"
    password="followme123#"
    login(username,password)
    sleep 3;
    188.downto(181).each do |i|
      username="物流零距离-"+"%03d" % i
      password="followme123#"
      mail_account="w090_"+"%03d" % i
      add_new_user(username,password,mail_account)
      sleep 1;
    end  
    
  end
  
  
  def test_login_and_change_password_for_each_account
         $browser.goto($site_root)
    199.downto(1).each do |i|
      username="w090_"+"%03d" % i+"@w090.com"
      password="followme123#"
      $browser.text_field(:name, "userAtDomain").set(username)
      $browser.text_field(:name, "password").set(password)
      $browser.button(:text, "登 录").click;sleep 1 
      $browser.text_field(:name, "password").set("w090w090#")
      $browser.text_field(:name, "cpassword").set("w090w090#")        
      $browser.checkbox(:name, "confirm").set
      $browser.button(:text, "进入邮箱").click;sleep 1  
      
     $browser.goto($site_root);sleep 1 
    end
  end
  
  
  
end
