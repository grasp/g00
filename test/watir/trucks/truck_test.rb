#coding:utf-8

require 'pathname'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent.parent #do we have one line solution?
require File.join(project_root,"test","watir","init_test.rb")


class W090NewTruckTest < ActiveSupport::TestCase
  def setup
    #create new user at first
   prepare_watir     
   define_user_1    
    @browser.goto("#{@site_root}")
    user_logout(@browser);sleep 1  
    user_fill_register_form(@browser,@site_root,@user_name1,@user_email1,"1234567",@mobile_phone1)  
    user_logout(@browser)  
  end
  
  test "new truck" do
     @browser.goto("#{@site_root}/trucks/allcity")
      ["出发地选择","到达地选择","待报价车源"].each { |text| assert @browser.text.include?(text),"#{text} 不存在 !!"}
     user_logout(@browser)   #make sure user is logout      
     @browser.goto("#{@site_root}//users/center");sleep 2     
     user_login(@browser,@site_root,@user_name1,'1234567')
     
     @browser.goto("#{@site_root}/stock_trucks/new");sleep 2  #stupid ,should go to company new
       ["新增车辆","车辆牌照","车厢结构"].each { |text| assert @browser.text.include?(text),"#{text} 不存在 !!"}
       @user_name1.slice(6,8).gsub("-","").to_s
       paizhao=@user_name1.slice(6,8).gsub("-","").to_s
       create_stock_truck(@browser,paizhao,"12","12","普通运输","平板","无",@user_name1,
       @mobile_phone1,@user_name1,@mobile_phone1,@user_name1,@mobile_phone1,"东风货车","X5","2011")   
       @browser.goto("#{@site_root}/users/stock_trucks");sleep 2  #stupid ,should go to company new
      ["发布车源",paizhao].each { |text| assert @browser.text.include?(text),"#{text} 不存在 !!"}
      @browser.link(:url,/trucks\/new/).click;sleep 5
       ["发布车源",paizhao,"请选择出发地","请选择到达地"].each { |text| assert @browser.text.include?(text),"#{text} 不存在 !!"}
    create_truck(@browser,"浙江","杭州市","江苏","常熟市","二天","回程车","急发，价格高")
    
  end
end
