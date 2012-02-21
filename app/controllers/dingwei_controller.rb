#coding:utf-8
class DingweiController < ApplicationController
  
  layout "dingwei"
  
  def userannounce
    @user_annouce=true
  end
  
  def index
    
  end
  
  def bind    
    @stock_truck=StockTruck.find(params[:id])   
    if @stock_truck.bind==true
      @stock_truck.update_attribute(:bind,false)
      flash[:notice]="成功松绑，过一个小时后，手机将不再上传位置，客户端定位功能将失效"
    else
      @stock_truck.update_attribute(:bind,true)
      flash[:notice]="成功绑定，只要手机上安装了物流零距离客户端，就可以定位#{ @stock_truck.paizhao}了"
    end    
    
    respond_to do |format|
      format.html {redirect_to :action=>"list_all_truck",:notice=>flash[:notice]}
      format.xml  { render :xml => @stock_trucks }
    end    
  end
  
  def newtruck
    @stock_truck = StockTruck.new
    @user=User.find(session[:user_id])
    @stock_truck.user_id=@user.id
    @stock_truck.status="空闲"
    @stock_truck.company_id=@user.company_id unless @user.nil? 
    
  end
  
  def weizhi
    @stock_truck=StockTruck.find(params[:id])   
    unless @stock_truck.nil?
      @lng=@stock_truck.lat
      @lat=@stock_truck.lng
      @markers = "[
             {'description'=>'Hi', 'title'=>'test', 'sidebar'=>'', 'lng'=>#{@lng}, 'lat'=>#{@lat}, 'picture'=>'', 'width'=>'940', 'height'=>'800'},
             {'lng'=>#{@lng}, 'lat'=>#{@lat} }
            ]"
    end  
  end
   
  def guiji
    location_array=Array.new
    location_array_array=Array.new
    markers_array=Array.new
    @stock_truck=StockTruck.find(params[:id])   
    @truck_location=TruckLocation.new(:paizhao=>@stock_truck.paizhao,:mphone=>@stock_truck.driver_phone)
    @truck_location.update_attribute(:history, [])
    @truck_location.history.push({"lng" =>116.416373, "lat"=>39.928584,"speed"=>30,"timetag"=>2011-12-12})
    @truck_location.history.push({"lng"=>116.36561, "lat"=>39.912445,"speed"=>30,"timetag"=>2011-12-12})
    @truck_location.history.push({"lng"=>116.407413, "lat"=>39.904214,"speed"=>30,"timetag"=>2011-12-12})
    # poly_array=[[{"lng" =>116.416373, "lat"=>39.928584,"speed"=>30,"timetag"=>2011-12-12}, {"lng"=>116.36561, "lat"=>39.912445,"speed"=>30,"timetag"=>2011-12-12},  {"lng"=>116.407413, "lat"=>39.904214,"speed"=>30,"timetag"=>2011-12-12} ]]
    # @polylines ='[ [  {"lng"=>116.416373, "lat"=>39.928584,"speed":30,"timetag":2011-12-12},  {"lng"=>116.36561, "lat"=>39.912445},  {"lng"=>116.407413, "lat"=>39.904214} ]]'
    @truck_location.history.each do |location|
      location_array<<location
    end
    markers_array<<{'description'=>'Hi', 'title'=>'test', 'sidebar'=>'',"lng" =>116.416373, "lat"=>39.928584 ,'width'=>'', 'height'=>''}
    markers_array<<{"lng"=>116.36561, "lat"=>39.912445}
    @markers= markers_array.to_json
    
    puts @markers
    location_array_array<<location_array
    puts location_array_array
    @polylines= location_array_array.to_json
    puts @polylines
  end
  
  def list_all_truck
    @stock_trucks = StockTruck.where(:user_id =>session[:user_id]).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
      
  end
  

  
 
  
  
end
