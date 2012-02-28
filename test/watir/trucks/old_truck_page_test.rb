#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class TruckCargoPageTest < ActiveSupport::TestCase

  test "public user search truck" do
    puts "public user search truck"
    $browser.goto("#$site_root")
    assert $browser.link(:id, "che_info").click;    sleep 1
    result=$browser.text.force_encoding('utf-8')
    ["车辆","出发地","到达地","有效期"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"}  
    
   #click page 2
   2.downto(1).each do |i|
   assert assert $browser.button(:value, "查询").click;  sleep 1  
   result=$browser.text.force_encoding('utf-8')
   ["关于物流零距离","货源信息","车源信息"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 
   end
   
    puts "01-click  line select-W090CargoPageTest"
    line_select("浙江","杭州市","浙江","绍兴市")
    
    #
    #click search
   assert $browser.button(:value, "查询").click;  sleep 1
   result=$browser.text.force_encoding('utf-8')
   ["车辆","浙江","关于物流零距离","货源信息","车源信息"].each { |text|  assert result.include?(text),"#{text} 不存在 !!"} 



   #click next page search
   
  end
  
end
