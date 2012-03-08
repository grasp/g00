#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
if false
  ENV["RAILS_ENV"] = "test"
  start_time=Time.now
  require 'watir'
  require  'rubygems'
  require 'active_support/all'
  require "test/unit"
  puts "load test env cost #{Time.now-start_time} sec"
end


class W090UserPageTest < ActiveSupport::TestCase
  
test "user_register_login_logout" do 
  #"0-any_user_should_see_first_page"
    puts "0any user should see first page"
    #open index
    #
    #check navi text and bottom text
  assert $browser.text.force_encoding('utf-8')
  ["关于物流零距离","货源信息","车源信息","联系我们"].each {|text|   assert $browser.text.include?(text),"#{text} 不存在 !!"}

  #"1-user open register form" 
  
    puts "1-user open register form"
    result=$browser.text.force_encoding('utf-8')
    if result.include?("登出")
      $browser.link(:href, "#{$site_root}/users/logout").click;sleep 0.5
    else
      $browser.goto("#{$site_root}")
    end
    sleep 1
    
    assert $browser.link(:href, "#{$site_root}/users/new").click
    ["欢迎来到物流零距离","用户名","Email","密码"].each {|text|   assert $browser.text.include?(text),"#{text} 不存在 !!"}

  #"2-user click button without any fill"
    puts "2user click button without any fill"
    $browser.link(:href, "#{$site_root}/users/new").click;sleep 0.5
    
    assert $browser.button(:id, "user_submit").click;sleep 0.5
    ["用户名不能为空","email不能为空","密码不能为空","联系手机不能为空"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}

#"3-user name should unique when create" 
    puts "3user name should unique when create"
    #admin create should fail
    sleep 1
    $browser.link(:href, "#{$site_root}/users/new").click
    $browser.text_field(:id, "user_name").set("admin")
    $browser.text_field(:id, "user_email").set("admin@gmail.com")
    $browser.text_field(:id, "user_password").set("admin111")
    $browser.text_field(:id, "user_password_confirmation").set("admin111")
    $browser.text_field(:id, "user_mobilephone").set("13788901123")
    
    assert $browser.button(:id, "user_submit").click
   ["该用户名已经存在"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
 
#user register and login" 
    puts "user login and logout"
    assert $browser.goto "#{$site_root}"
    ["登录","货源信息","快速注册,永久免费","车源信息","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    #login test
    sleep(1)
    $browser.link(:href, "#{$site_root}/users/login").click
    ["欢迎来到物流零距离","用户登录","密码","用户名或Email"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    $browser.text_field(:id, "email").set($user_name1)
    $browser.text_field(:id, "password").set("1234567")
    $browser.button(:value, "登录").click;sleep 0.5
  
    ["登出","我的货源","我的车源","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    sleep(1) #need wait enough time here
    $browser.link(:href, "#{$site_root}/users/logout").click
    sleep(1)
 

 #"5repeated username register" 
    puts " 5repeated username register"
    
   result=$browser.text.force_encoding('utf-8')
    if result.include?("登出")
      $browser.link(:href, "#{$site_root}/users/logout").click
    end
    
    sleep 2
    $browser.link(:href, "#{$site_root}/users/new").click
    $browser.text_field(:id, "user_name").set($user_name1)
    $browser.text_field(:id, "user_email").set("#{$user_name1+"1"}@gmail.com")
    $browser.text_field(:id, "user_password").set("1234567")
    $browser.text_field(:id, "user_password_confirmation").set("1234567")
    $browser.text_field(:id, "user_mobilephone").set($mobile_phone1.chop+"1")
    
    $browser.button(:id, "user_submit").click
    ["该用户名已经存在"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}

  
 # "6repeated email regester" 
    puts "6 repeated email regester"
    $browser.link(:href, "#{$site_root}/users/new").click
    $browser.text_field(:id, "user_name").set($user_name1.chop+"1")
    $browser.text_field(:id, "user_email").set("#{$user_name1}@gmail.com")
    $browser.text_field(:id, "user_password").set("1234567")
    $browser.text_field(:id, "user_password_confirmation").set("1234567")
    $browser.text_field(:id, "user_mobilephone").set($mobile_phone1.chop+"2")
    
    $browser.button(:id, "user_submit").click
    ["该email已经存在"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}

    puts "7 repeated mobile phone register"
    $browser.link(:href,"#{$site_root}/users/new").click
    $browser.text_field(:id, "user_name").set($user_name1.chop+"2")
    $browser.text_field(:id, "user_email").set("#{$user_name1.chop+"2"}@gmail.com")
    $browser.text_field(:id, "user_password").set("1234567")
    $browser.text_field(:id, "user_password_confirmation").set("1234567")
    $browser.text_field(:id, "user_mobilephone").set($mobile_phone1)
    
    $browser.button(:id, "user_submit").click
    ["该手机已经存在"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}


  puts "user login as email account" 
    $browser.link(:href, "#{$site_root}/users/login").click
    $browser.text_field(:id, "email").set($user_email1)
    $browser.text_field(:id, "password").set("1234567")
    $browser.button(:value, "登录").click; sleep 0.5
    ["登出","我的货源","我的车源","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}

    puts "test user forget email"
   
     logout
     sleep 1;$browser.link(:text, "登录").click;sleep 0.5
    ["新用户注册","用户名或Email"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
     $browser.link(:text, "忘记密码").click;sleep 0.5
     ["密码重置","你的邮箱"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     logout_and_login($user_name2)
end
end
