#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class W090NewCompanyTest < ActiveSupport::TestCase
  def setup
   prepare_watir     
    @user_name1=Time.now.to_s.gsub(/\s|:|\+/,"").to_s 
    @user_email1="#{@user_name1}@gmail.com"
    @mobile_phone1=@user_name1.slice(9,18)
    @paizhao1=@mobile_phone1.slice(0,6)
        
    user_logout(@browser)  
    user_fill_register_form(@browser,@site_root,@user_name1,@user_email1,"1234567",@mobile_phone1)  
    user_logout(@browser)  
  end
end
