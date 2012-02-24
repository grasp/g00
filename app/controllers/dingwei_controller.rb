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
     # @lng=@stock_truck.loc[0]
    #  @lat=@stock_truck.loc[1]
        @lng=@stock_truck.source[:lng]  #why is hash ,we store it as array !
      @lat=@stock_truck.source[:lat]
      @markers = "[
             {'description': 'Hi', 'title': 'test', 'sidebar': '', 'lng': #{@lng}, 'lat': #{@lat}, 'picture': '', 'width': '940', 'height': '800'},
             {'lng': #{@lng}, 'lat': #{@lat} }
            ]"
    end  
  end
   
  def guiji
    location_array=Array.new
    location_array_array=Array.new
    markers_array=Array.new
    @stock_truck=StockTruck.find(params[:id])   
    #@truck_location=TruckLocation.new(:paizhao=>@stock_truck.paizhao,:mphone=>@stock_truck.driver_phone)
    #   @truck_location.update_attribute(:history, [])
    @truck_location=TruckLocation.where(:mphone=>@stock_truck.driver_phone).first
    #  @truck_location.update_attribute(:history,[])
    @truck_location.history.each do |location|
      location_array<<location

    end

    # puts "first location=#{@truck_location.history.first}"
    #   puts "lase location=#{@truck_location.history.last}"
    @center_longitude=(@truck_location.history.first["lng"]+@truck_location.history.last["lng"])/2
    @center_latitude=(@truck_location.history.first["lat"]+@truck_location.history.last["lat"])/2
    markers_array<<{"lng"=>@truck_location.history.first["lng"], "lat"=>@truck_location.history.first["lat"]}
    markers_array<<{"lng"=>@truck_location.history.last["lng"], "lat"=>@truck_location.history.last["lat"]}
    @markers= markers_array.to_json       

    
    # puts "@center_latitude=#{@center_latitude},@center_longitude=#{@center_longitude}"    

    location_array_array<<location_array
    @polylines= location_array_array.to_json
    # puts @polylines
  end
  
  def list_all_truck
    @stock_trucks = StockTruck.where(:user_id =>session[:user_id]).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)      
  end
  
  def post_gps
    new_location= eval(params[:location]).to_hash  
    if new_location[:mphone]
      @stock_truck=StockTruck.where(:driver_phone=> new_location[:mphone]).first
      @stock_truck.update_attributes(:loc=>[new_location[:lng],new_location[:lat]] ,:speed=> new_location[:speed],:timetag=>Time.now) unless @stock_truck.blank?  
      #now store to history
      @truck_location=TruckLocation.where(:mphone=> new_location[:mphone]).first
   
      TruckLocation.create!(:mphone=> new_location[:mphone],:truck_id=> @stock_truck.id,:paizhao=>@stock_truck.paizhao,:history=>Array.new) if  @truck_location.blank?
      @truck_location=TruckLocation.where(:mphone=> new_location[:mphone]).first
      #   puts   "mphone=#{@truck_location.mphone},id=#{@truck_location.truck_id},history size=#{@truck_location.history.size}"   
      @truck_location.add_to_set(:history,{"lng" =>new_location[:lng].to_f, "lat"=>new_location[:lat].to_f,"speed"=>new_location[:speed],"timetag"=>Time.now})      
      # puts   "truck_location.history size=#{@truck_location.history.size}"+ @truck_location.history.to_s
    end
  end
  
   def neartruck
    city=City.where(:code=>params[:citycode]).first
  #  @stock_trucks = StockTruck.where(:loc.near => city.loc, :max => params[:distance], :unit => :km).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)    
  # @stock_trucks = StockTruck.where(:loc.near => {:point => city.loc, :max => 500, :unit => :km}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)     
    # @stock_trucks=   StockTruck.geo_near(city.loc, :max_distance => 100, :unit => :km, :spherical => true)#.desc(:created_at).per(25).page(1)
 @stock_trucks = StockTruck.where(:loc.near => {:point => city.loc, :max => params[:distance],:unit=>:km})
  end
  

  
 
  
  
end
