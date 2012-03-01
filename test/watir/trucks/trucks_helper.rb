#coding:utf-8

  def create_stock_truck(browser,paizhao,weight,length,usage,chexiang,gps,jiaoche_person,
      jiaoche_phone,driver_person,driver_phone,owner,owner_phone,brand,xinghao,year)    
   
    browser.text_field(:id,"stocktruck_paizhao").set(paizhao)
    browser.text_field(:id,"stocktruck_dun_wei").set(weight)
    browser.text_field(:id,"stocktruck_che_length").set(length)
    browser.select_list(:id,"stocktruck_truck_usage").set(usage)
    browser.select_list(:id,"stocktruck_truck_shape").set(chexiang)
    browser.select_list(:id,"stocktruck_truck_gps").set(gps)
    browser.text_field(:id,"stocktruck_bis_name").set(jiaoche_person)
    browser.text_field(:id,"stocktruck_bis_phone").set(jiaoche_phone)
    browser.text_field(:id,"stocktruck_driver_name").set(driver_person)
    browser.text_field(:id,"stocktruck_driver_phone").set(driver_phone)
    browser.text_field(:id,"stocktruck_owner_name").set(owner)
    browser.text_field(:id,"stocktruck_owner_phone").set(owner_phone)      
    browser.select_list(:id,"stocktruck_truck_pinpai").set(brand)
    browser.text_field(:id,"stocktruck_truck_xinghao").set(xinghao)
    browser.select_list(:id,"stocktruck_truck_year").set(year)
    
    #click create
    sleep 0.3
    assert browser.button(:name,"commit").click;sleep 1
    ["成功创建车辆","#{paizhao}"].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}
    
  end
  
 
  def create_truck(browser,from_province,from_city,to_province,to_city,day,huicheng,comments)
  line_select(browser,from_province,from_city,to_province,to_city)
  browser.select_list(:id,"truck_send_date").set(day)
  browser.select_list(:id,"truck_huicheng").set(huicheng)
  browser.text_field(:id,"truck_comments").set(comments)
  browser.button(:name,"commit").click;sleep 0.6
  
  ["车源创建成功",from_city,to_province,"继续发布车源",].each { |text| assert browser.text.include?(text),"#{text} 不存在 !!"}
  return true
end
  


  
