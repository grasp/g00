 # coding: utf-8
class StockTrucksController < ApplicationController
  # GET /stock_trucks
  # GET /stock_trucks.xml
  before_filter:authorize
  protect_from_forgery :except => [:tip,:login]
  include StockTrucksHelper
  #layout "public", :except => [:oper]
  layout :choose_layout
  
    def choose_layout
    return nil if action_name=='show'
    return 'usercenter' if action_name=='index' || action_name=='new' || action_name=='edit'
    return 'public'
  end
  def index
   @stock_trucks = StockTruck.where(:user_id =>session[:user_id]).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>5)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stock_trucks }
    end
  end    



  # GET /stock_trucks/1
  # GET /stock_trucks/1.xml
  def show
    @stock_truck = StockTruck.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_truck }
    end
  end

  # GET /stock_trucks/new
  # GET /stock_trucks/new.xml
  def new
    @stock_truck = StockTruck.new
    @user=User.find(session[:user_id])
    @stock_truck.user_id=@user.id
    @stock_truck.status="空闲"
    @stock_truck.company_id=@user.company_id unless @user.nil?

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock_truck }
    end
  end

  def oper
    @stock_truck_id =params[:id]
     respond_to do |format|
      format.html # oper.html.erb
   #   format.xml  { render :xml => @stock_truck }
    end
  end

  # GET /stock_trucks/1/edit
  def edit
    @stock_truck = StockTruck.find(params[:id])    
  end

  # POST /stock_trucks
  # POST /stock_trucks.xml
  def create
    @user=User.find(session[:user_id])
    stocktruck=params[:stocktruck]
    
   # logger.info(params[:stocktruck])
   #  logger.info(params[:stocktruck][:favo_city])
    stocktruck[:truckcount]=0 #clear the counter
    stocktruck[:status]="车辆闲置" #clear the counter
    
    #initialize statistic 
     stocktruck[:valid_truck]=0;     stocktruck[:total_truck]=0;     stocktruck[:expired_truck]=0
     
     stocktruck[:user_id]=@user.id
     @stock_truck = StockTruck.new(stocktruck)

    respond_to do |format|
      if @stock_truck.save
        flash[:notice] = '成功创建车辆'
        Ustatistic.collection.update({'user_id'=>session[:user_id]},
        {'$inc' => {"total_stock_truck" => 1}},{:upsert =>true})
     #   format.html { redirect_to :action=>"index"}
       format.html {redirect_to :controller=>"dingwei",:action=>"list_all_truck",:notice=>flash[:notice]}
      #  format.xml  { render :xml => @stock_truck, :status => :created, :location => @stock_truck }
      else
        flash[:notice] = '创建车辆失败,该牌照已经存在'
      #  format.html { render :action => "new" }
          format.html {redirect_to :controller=>"dingwei",:action=>"newtruck",:notice=>flash[:notice]}
      #  format.xml  { render :xml => @stock_truck.errors, :status => :unprocessable_entity }
      end
    end
   
  end

  # PUT /stock_trucks/1
  # PUT /stock_trucks/1.xml
  def update
    @stock_truck = StockTruck.find(params[:id])

    respond_to do |format|
      if @stock_truck.update_attributes(params[:stocktruck])
        flash[:notice] = '成功更新了车子基本信息.'
        
        format.html { redirect_to :action=>"index" }
        format.xml  { head :ok }
      else
         flash[:notice] = '更新车子基本信息失败.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_truck.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_trucks/1
  # DELETE /stock_trucks/1.xml
  def destroy    
    @stock_truck = StockTruck.find(params[:id])
    @stock_truck.destroy

    respond_to do |format|
      format.html { redirect_to(stock_trucks_url) }
      format.xml  { head :ok }
    end
  end
end
