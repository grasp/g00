# To change this template, choose Tools | Templates
# and open the template in the editor.


def prepare_watir
    @browser =Watir::IE.new
    @browser.speed = :fast
    # @browser.minimize
    @site_root= "http://localhost:4500"  
end

def define_user_1
    @user_name1=Time.now.to_s.gsub(/\s|:|\+/,"").to_s 
    @user_email1="#{@user_name1}@gmail.com"
    @mobile_phone1=@user_name1.slice(9,18)
    @paizhao1=@mobile_phone1.slice(0,6)
end

def define_user_2
    @user_name2=Time.now.to_s.gsub(/\s|:|\+/,"").to_s 
    @user_email2="#{@user_name2}@gmail.com"
    @mobile_phone2=@user_name2.slice(9,18)
    @paizhao2=@mobile_phone2.slice(0,6)
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

def user_logout_login(browser,site_root,username,password)
    if browser.text.match("退出")
    browser.link(:text, "退出").click;sleep 1
  end
  browser.goto("#{site_root}/users/login")
  browser.text_field(:id, "email").set(username)
  browser.text_field(:id, "password").set(password)
  browser.button(:value, "登  录").click;sleep 0.5
end
