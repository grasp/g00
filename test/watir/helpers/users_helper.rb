#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

def user_fill_register_form(browser,site_root,user_name,user_email,password,mobile_phone)
  browser.link(:href, "#{site_root}/users/new").click;sleep 2
  browser.text_field(:id, "user_name").set(user_name)
  browser.text_field(:id, "user_email").set(user_email)
  browser.text_field(:id, "user_password").set(password)
  browser.text_field(:id, "user_password_confirmation").set(password)
  browser.text_field(:id, "user_mobilephone").set(mobile_phone)
  browser.button(:name, "commit").click;
end

def user_login(browser,site_root,username,password)
  browser.goto("#{site_root}/users/login")
  browser.text_field(:id, "email").set(username)
  browser.text_field(:id, "password").set(password)
  browser.button(:value, "登  录").click;sleep 0.5
end

def user_logout(browser)
  if browser.text.match("退出")
    browser.link(:text, "退出").click;sleep 1
  end
end
