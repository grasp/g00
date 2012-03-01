#coding:utf-8
require 'pathname'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent.parent #do we have one line solution?
require File.join(project_root,"test","watir","init_test.rb")

class  W090UserLoginLogoutTest <ActiveSupport::TestCase

  def setup
    prepare_watir
    define_user_1
    sleep 5
    define_user_2
    
    @browser.goto("#{@site_root}")
    user_logout(@browser)  
    user_fill_register_form(@browser,@site_root,@user_name1,@user_email1,"1234567",@mobile_phone1)  
    user_logout(@browser)     
    
    @browser.goto("#{@site_root}");sleep 1
    user_fill_register_form(@browser,@site_root,@user_name2,@user_email2,"1234567",@mobile_phone2)
    user_logout(@browser)  
  end

  test "user_login" do 
    user_logout_login(@browser,@site_root,@user_name1,"1234567")
    user_logout_login(@browser,@site_root,@user_email1,"1234567")
    user_logout_login(@browser,@site_root,@user_name2,"1234567")
    user_logout_login(@browser,@site_root,@user_email2,"1234567")
  end
  
  
end


