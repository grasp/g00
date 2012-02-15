#coding:utf-8

require 'pathname'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent.parent #do we have one line solution?
require File.join(project_root,"test","watir","w090_test_common.rb")
require File.join(project_root,"test","watir","users","users_helper.rb")
require File.join(project_root,"test","watir","cargos","cargos_helper.rb")

class W090NewCompanyTest < ActiveSupport::TestCase
  def setup
    prepare_watir     
    define_user_1    
    @browser.goto("#{@site_root}")
    user_logout(@browser);sleep 1  
    user_fill_register_form(@browser,@site_root,@user_name1,@user_email1,"1234567",@mobile_phone1)  
    user_logout(@browser)  
  end
  
  test "new stockcargo" do
    user_logout_login(@browser,@site_root,@user_name1,"1234567")
    @browser.goto("#{@site_root}/users/stock_cargos")
    @browser.link(:text, "添加新的货物").click;sleep 0.5  
    create_stock_cargo(@browser,@site_root)   
    
  end
  
  test "new cargo" do 
     @browser.goto("#{@site_root}/users/stock_cargos")
     
  end
end
