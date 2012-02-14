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


class  W090UserLoginLogoutTest <ActiveSupport::TestCase

  def initialize
     @browser =Watir::IE.new
     @browser.speed = :fast
    # @browser.minimize
     @site_root= "http://localhost:4500"  
     
    @user_name1=Time.now.to_s.gsub(/\s|:|\+/,"").to_s 
    @user_email1="#{@user_name1}@gmail.com"
    @mobile_phone1=@user_name1.slice(9,18)
    @paizhao1=@mobile_phone1.slice(0,6)
  
   @user_name2=Time.now.to_s.gsub(/\s|:|\+/,"").to_s 
   @user_email2="#{@user_name2}@gmail.com"
   @mobile_phone2=@user_name2.slice(9,18)
   @paizhao2=@mobile_phone2.slice(0,6)
  end


def login
  @browser.goto("#{@site_root}")
  @browser.link(:href, "#{@site_root}/users/new").click
  @browser.text_field(:id, "user_name").set(@user_name1)
  @browser.text_field(:id, "user_email").set(@user_email1)
  @browser.text_field(:id, "user_password").set("1234567")
  @browser.text_field(:id, "user_password_confirmation").set("1234567")
  @browser.text_field(:id, "user_mobilephone").set(@mobile_phone1)
  @browser.button(:class, "primary").click;sleep 0.5
   if @browser.text.match("登出")
      @browser.link(:text, "登出").click;sleep 1
   end
   
   @browser.goto("#{@site_root}")
  @browser.link(:href, "#{@site_root}/users/new").click
  @browser.text_field(:id, "user_name").set(@user_name2)
  @browser.text_field(:id, "user_email").set(@user_email2)
  @browser.text_field(:id, "user_password").set("1234567")
  @browser.text_field(:id, "user_password_confirmation").set("1234567")
  @browser.text_field(:id, "user_mobilephone").set(@mobile_phone2)
  @browser.button(:class, "primary").click;sleep 0.5
   if @browser.text.match("登出")
      @browser.link(:text, "登出").click;sleep 1
   end

end
  
end


