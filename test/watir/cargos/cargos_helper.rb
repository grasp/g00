#coding:utf-8

#require 'pathname'
#pn = Pathname.new(File.dirname(__FILE__))
#project_root=pn.parent.parent.parent #do we have one line solution?
#require File.join(project_root,"test","watir","init_test.rb")

def create_stock_cargo(browser,site_root)
  browser.select_list(:id, "stockcargo_big_category").set("大件货物")
  browser.link(:text, "类别选择").click; ;sleep 2
  browser.link(:href, "#{site_root}/cargo_categories/show/010000").click;sleep 2
  browser.link(:href, "#{site_root}/cargo_categories/show/010200").click;sleep 1
  browser.link(:id, "list_closec").click;     
  browser.link(:text, "包装选择").click;sleep 2  
  browser.link(:href, "#{site_root}/package_categories/show/9000").click;sleep 2
  browser.link(:href, "#{site_root}/package_categories/show/9993").click;sleep 1
  browser.link(:id, "list_closep").click;sleep 0.5    
  browser.button(:name, "commit").click;sleep 0.5; ["货物创建成功","货物闲置","大件货物"].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}
     return true  
end
  

def create_cargo(browser,from_province,from_city,to_province,to_city,weight,bulk,day,zuhuo)
  line_select(browser,from_province,from_city,to_province,to_city)
  browser.text_field(:id,"cargo_cargo_weight").set(weight)
  browser.text_field(:id,"cargo_cargo_bulk").set(bulk)
  browser.select_list(:id,"cargo_send_date").set(day)
  browser.select_list(:id,"cargo_cargo_zuhuo").set(zuhuo)
  browser.button(:name,"commit").click;sleep 0.6
  ["货物","出发","到达","继续发布货源",].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}
  return true
end