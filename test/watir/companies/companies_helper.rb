#coding:utf-8

  def create_company(browser,name)
 
    introduction="测试使用，本物流公司面向全国各地，请诸位货主联系！"
    employer="10"
    truck="100"
    address="物流园3456号"
    quhao="021"
    fixphone="12345678"
    mobilephone=@mobile_phone1
    email=@user_email1
   contact="胡先生"
    browser.text_field(:id, "company_name").set(name)
    browser.text_field(:id, "company_about").set(introduction)
    browser.text_field(:id, "company_num_employ").set(employer)
    browser.text_field(:id, "company_self_che").set(truck)
    browser.text_field(:id, "company_contact_name").set(contact)
     
     
    browser.text_field(:id, "company_address").set(address)
    browser.text_field(:id, "quhao").set(quhao)
    browser.text_field(:id, "companyfix_phone").set(fixphone)
    browser.text_field(:id, "company_mobile_phone").set(mobilephone)
    browser.text_field(:id, "company_email").set(email)
    
    browser.button(:name, "commit").click;sleep 1
    
  
          
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
  
