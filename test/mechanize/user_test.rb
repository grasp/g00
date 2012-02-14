#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.



class UserTest < ActiveSupport::TestCase
    def initialize
    @user_browser= Mechanize.new
  end  
  def login
     @user_browser.get("http://localhost:4500")
  end
  
end
