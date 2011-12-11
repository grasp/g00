#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class W090NewCompanyTest < ActiveSupport::TestCase

  def create_company(name,introduction,employer,truck,contact,city_province,city,address,quhao,fixphone,mobilephone,email)
    assert $browser.link(:text, "完善公司信息").click;sleep 0.5
    ["完善公司信息","公司名称","公司介绍","员工数量"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    $browser.text_field(:id, "company_name").set(name)
    $browser.text_field(:id, "company_about").set(introduction)
    $browser.text_field(:id, "company_num_employ").set(employer)
    $browser.text_field(:id, "company_self_che").set(truck)
    $browser.text_field(:id, "company_contact_name").set(contact)
     
    assert $browser.link(:id, "from_data_load").click;sleep 0.5
    ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:text, "#{city_province}").click;sleep 0.5
    ["浙江","上海","北京","西藏"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     
    assert $browser.link(:text, "#{city}").click;sleep 0.5
    ["#{city_province}","#{city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:id, "from_data_load").click;sleep 0.5
    ["#{city_province}","#{city}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     
    $browser.text_field(:id, "company_address").set(address)
    $browser.text_field(:id, "quhao").set(quhao)
    $browser.text_field(:id, "companyfix_phone").set(fixphone)
    $browser.text_field(:id, "company_mobile_phone").set(mobilephone)
    $browser.text_field(:id, "company_email").set(email)
    
    $browser.button(:id, "company_submit").click;sleep 1
    
   ["我的公司","货源信息","车源信息"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
          
  end
  
  
  def private_user_create_company (username)
   
    logout_and_login(username)
    puts  "validate company"
    assert $browser.link(:text, "完善公司信息").click;sleep 0.5
    ["完善公司信息","公司名称","公司介绍","员工数量"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
     $browser.button(:id, "company_submit").click;sleep 1
    ["名字没有填写","介绍不能为空","联系人没有提供","没有选择所在城市","需要提供公司地址",""].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
   $browser.goto("#{$site_root}");sleep 0.5
    puts "private user create company"
    create_company("#{username}_汉江物流有限公司","我们是一家很棒的物流公司,\r\n我们是一家很棒的物流公司我们是一家很棒的,\r\n物流公司我们是一家很棒的物流公司我们是一家很棒的物流公司 \
      我们是一家很棒的物流公司我们是一家很棒的物流\r\n公司我们是一家很棒的物流公司我们是一家很棒的\n物流公司我们是一家很棒的物流公司我们是一家很棒的物流公司我们是一家很棒的\
     物流公司我们是一家很棒的物流公司我们是一家很棒的物流公司\n我们是一家很棒的物流公司我们是一家很棒的物流公司","20","5","张三丰","浙江","杭州市","石大路市场123号","0571","82876543","17898761234","#{username}hu@gmail.com")
   #now check information is there
    assert $browser.link(:text, "我的公司").click;sleep 0.5
    ["#{username}_汉江物流有限公司","我们是一家很棒的物流公司","20","5","张三丰","浙江","杭州市","石大路市场123号","0571","82876543","17898761234","hu@gmail.com"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
  end
    def test_private_user_create_company 
      private_user_create_company($user_name1)
    end
  
end
