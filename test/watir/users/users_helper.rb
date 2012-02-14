#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

def user_fill_register_form(browser,site_root,user_name,user_email,password,mobile_phone)
  browser.link(:href, "#{site_root}/users/new").click
  browser.text_field(:id, "user_name").set(user_name)
  browser.text_field(:id, "user_email").set(user_email)
  browser.text_field(:id, "user_password").set(password)
  browser.text_field(:id, "user_password_confirmation").set(password)
  browser.text_field(:id, "user_mobilephone").set(mobile_phone)
  browser.button(:name, "commit").click;
end


