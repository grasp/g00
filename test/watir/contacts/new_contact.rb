#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class W090NewContactTest < ActiveSupport::TestCase

  def create_contact(name,mobile,quhao,fixphone,qq)
    assert $browser.link(:text, "完善联系方式").click;sleep 0.5
    ["用户联系信息","移动电话","Qq"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    $browser.text_field(:id, "usercontact_name").set(name)
    $browser.text_field(:id, "usercontact_mobilephone").set(mobile)
    $browser.text_field(:id, "user_contact_phone_quhao").set(quhao)
    $browser.text_field(:id, "user_contact_fix_phone").set(fixphone)
    $browser.text_field(:id, "usercontact_QQ").set(qq)
     
    
    $browser.button(:id, "usercontact_submit").click;sleep 1
    
   ["#{name}","#{mobile}","#{qq}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
          
  end
  
  
  def private_user_create_contact (username,mobile_phone)
    
    logout_and_login(username)
    puts "test validate user contact"
    assert $browser.link(:text, "完善联系方式").click;sleep 0.5
    ["用户联系信息","移动电话","Qq"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     $browser.button(:id, "usercontact_submit").click;sleep 1
     ["真实姓名没有填写"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     
    puts "private user create contact"
    create_contact("张三","#{mobile_phone}","021","98761234","179876541")
    
    #now check information is there
    assert $browser.link(:id, "my_contact").click;sleep 0.5
    ["张三","#{mobile_phone}","021","98761234","179876541"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
  end
  
 def test_private_user_create_contact
   private_user_create_contact($user_name1,$mobile_phone1)
 end
  
end
