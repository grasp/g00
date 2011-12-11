#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

class W090NewStockCargoTest < ActiveSupport::TestCase
  
  def create_stock_cargo(big_cate,huo_dalei,huo_xiaolei,pack_dalei,pack_xiaolei)
    
    #click new stock cargo
    assert $browser.link(:text, "添加新的货物").click;sleep 0.5
    ["创建货物","货物大类","货物类别","货物包装"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
       
    $browser.select_list(:id, "stockcargo_big_category").set("#{big_cate}")
    #选择货物
    assert $browser.link(:text, "类别选择").click; sleep 0.5
    ["面谈","煤炭及制品","石油天然气及制品","货物大类"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
   
    assert $browser.link(:text, "#{huo_dalei}").click;sleep 0.5
    ["#{huo_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:text, "#{huo_xiaolei}").click;sleep 0.5
    ["#{huo_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:id, "list_closec").click;sleep 0.5
    ["#{huo_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    #选择包装
    assert $browser.link(:text, "包装选择").click;sleep 0.5
    ["包装大类","桶装","罐装","箱","袋装","特殊包装"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
   
    assert $browser.link(:text, "#{pack_dalei}").click;sleep 0.5
    ["#{pack_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:text, "#{pack_xiaolei}").click;sleep 0.5
    ["#{pack_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
   
    assert $browser.link(:id, "list_closep").click;sleep 0.5
    ["#{pack_xiaolei}"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}

    assert $browser.button(:id, "stockcargo_submit").click;sleep 0.5
    ["货物创建成功","货物闲置",].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    $browser.link(:text, "关闭").click;sleep 0.5
    
  end
  
  def create_cargo(from_province,from_city,to_province,to_city,weight,bulk,day,zuhuo)
    line_select(from_province,from_city,to_province,to_city)
    $browser.text_field(:id,"cargo_cargo_weight").set(weight)
    $browser.text_field(:id,"cargo_cargo_bulk").set(bulk)
    $browser.select_list(:id,"cargo_send_date").set(day)
    $browser.select_list(:id,"cargo_cargo_zuhuo").set(zuhuo)
    $browser.button(:id,"cargo_submit").click;sleep 0.6
    ["货物","出发","到达","继续发布货源",].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
  end

  def user_create_a_stock_cargo(username)
    puts "user #{username} create a stock cargo"
    logout_and_login(username)
    assert $browser.link(:id, "fabu_huo").click; sleep 0.5
    ["请先添加货物","添加新的货物","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}

    create_stock_cargo("普通货物","石油天然气及制品","煤 油","特殊包装","其他包装")
    #  create_stock_cargo("普通货物","非金属矿石","磷矿石","袋装","麻袋")
    #  create_stock_cargo("大件货物","木 材","原 木","特殊包装","裸装")
    #  create_stock_cargo("普通货物","粮 食","小 麦","袋装","麻袋")
    #  create_stock_cargo("普通货物","机械设备电器","农林牧渔业机械","特殊包装","挂装")
    # create_stock_cargo("普通货物","肥料及农药","动植物肥料","袋装","麻袋")
    #  create_stock_cargo("普通货物","有色金属","铜","桶装","闭口钢桶")
    
    all_links=Array.new
    #now 发布货源
    $browser.links.each do |link|
      all_links << link.href.to_s if link.href.match("/cargos/new")
    end
    
    all_links.each do |old_link|       
      assert $browser.link(:id, "fabu_huo").click; sleep 0.5   #first click 发布货源 
      ["添加新的货物","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
      
      assert  $browser.link(:href, "#{old_link}").click;;sleep 0.5 #click each links we remembered
      ["请选择出发地","请选择到达地","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
      create_cargo("浙江","杭州市","浙江","绍兴市","12","12","一天","零整不限")
      
      #second line for same cargo
      assert $browser.link(:id, "fabu_huo").click; sleep 0.5   #first click 发布货源
      ["正在配车"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
      assert  $browser.link(:href, "#{old_link}").click;;sleep 0.4 #click each links we remembered
      ["请选择出发地","请选择到达地","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
      create_cargo( "河南","宝丰县","湖北","广水市","12","12","二天","整车")
    end
    counter=0
    #click che_info
    $browser.link(:id,"che_info").click;sleep 0.5
    if $browser.links.each do |link|
        counter +=1
        break if counter>5
        if link.text.include?("询价")
          link.click;sleep 0.3
          ["出价","我的货物及其线路","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
          $browser.text_field(:id,"inquery_price").set("2000")
          $browser.select_list(:id,"inquery_cargo_id").set("煤 油(河南平顶山市宝丰县<=>湖北随州市广水市)")
          $browser.button(:id,"inquery_submit").click;sleep 0.4         
          ["询价创建成功"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
          $browser.link(:text,"关闭").click;sleep 0.2   
            
          link.click;sleep 0.4 
          ["出价","我的货物及其线路","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
          $browser.text_field(:id,"inquery_price").set("2000")
          $browser.select_list(:id,"inquery_cargo_id").set("煤 油(浙江杭州市<=>浙江绍兴市)")
          $browser.button(:id,"inquery_submit").click;sleep 0.4  
          ["询价创建成功"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
          $browser.link(:text,"关闭").click;sleep 0.2 
            
          link.click;sleep 0.3
          ["出价","我的货物及其线路","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
          $browser.text_field(:id,"inquery_price").set("2000")
          $browser.select_list(:id,"inquery_cargo_id").set("煤 油(河南平顶山市宝丰县<=>湖北随州市广水市)")
          $browser.button(:id,"inquery_submit").click;sleep 0.4         
          ["重复询价"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
          $browser.link(:text,"关闭").click;sleep 0.2   
            
          link.click;sleep 0.4 
          ["出价","我的货物及其线路","关于物流零距离"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
          $browser.text_field(:id,"inquery_price").set("2000")
          $browser.select_list(:id,"inquery_cargo_id").set("煤 油(浙江杭州市<=>浙江绍兴市)")
          $browser.button(:id,"inquery_submit").click;sleep 0.4  
          ["重复询价"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
          $browser.link(:text,"关闭").click;sleep 0.2
            
        end
      end
      
    end
    
    ### test form validation ####
    puts "test stock cargo and cargo validation"
    assert $browser.link(:id, "fabu_huo").click; sleep 0.5
    ["货物","包装","货物大类"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    assert $browser.link(:text, "添加新的货物").click; sleep 0.5
     ["货物大类","货物类别","货物包装"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     
     assert $browser.button(:id, "stockcargo_submit").click; sleep 0.5
     ["你还没有选择货物类别","你还没有选择包装类别"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
     
    #click and validate stockcargo and cargo fabu

    assert $browser.link(:id, "fabu_huo").click; sleep 0.5
    ["货物","包装","货物大类"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
    $browser.links.each do |link|
       if link.text=="发布货源" && link.href.to_s.match(/new/)
         link.click;sleep 0.5;
        ["请选择出发地","请选择到达地","有效天数"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
        break;
       end      
    end
    
    assert $browser.button(:id,"cargo_submit").click;sleep 0.5
    ["你还没有选择出发地","你还没有选择到达地","没有填写重量"].each { |text| assert $browser.text.include?(text),"#{text} 不存在 !!"}
    
  end
  
    def test_user_create_a_stock_cargo
      user_create_a_stock_cargo($user_name1)
     # user_create_a_stock_cargo($user_name2)
    end
 
end
