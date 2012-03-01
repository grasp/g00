#coding:utf-8

require 'pathname'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent.parent #do we have one line solution?
require File.join(project_root,"test","watir","w090_test_common.rb")
require File.join(project_root,"test","watir","users","users_helper.rb")
require File.join(project_root,"test","watir","companies","companies_helper.rb")

class W090NewCompanyTest < ActiveSupport::TestCase
  def setup
    #create new user at first
   prepare_watir     
   define_user_1    
    @browser.goto("#{@site_root}")
    user_logout(@browser);sleep 1  
    user_fill_register_form(@browser,@site_root,@user_name1,@user_email1,"1234567",@mobile_phone1)  
    user_logout(@browser)  
  end
  
  test "new company" do
     @browser.goto("#{@site_root}/companies/yellowpage")
      user_logout(@browser)   #make sure user is logout
      
     @browser.goto("#{@site_root}/companies/new");sleep 2     
     user_login(@browser,@site_root,@user_name1,'1234567')
     @browser.goto("#{@site_root}/companies/new");sleep 2  #stupid ,should go to company new
     company_name="#{@user_name1}物流有限公司"
     create_company(@browser,company_name)
  end
end
