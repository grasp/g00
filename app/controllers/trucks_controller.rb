# coding: utf-8
class TrucksController < ApplicationController
  # GET /trucks
  # GET /trucks.xml

  include TrucksHelper
  include CargosHelper
  # before_filter:authorize, :except => [:search,:show,:baojiatruck]
  before_filter:authorize, :only => [:new,:create,:update,:destroy,:edit,:quoteinquery,:request_chenjiao]
  protect_from_forgery :except => [:tip,:login]
  # layout "public"
  # caches_page :search,:show
  #  caches_page :show
  # layout 'public' ,:except => [:show,:search]
   
  layout :choose_layout  
  
  def choose_layout
    return 'usercenter'  if action_name =='index'      
    return  nil if  action_name=="show"
    return "usercenter" if action_name=="new"
    return 'truck'
  end
   
  def public
    @trucks =  Truck.all(:user_id =>session[:user_id])
    render :template => 'trucks/public/index'
  end

  def index
    unless params[:id].nil?
      @stock_truck=StockTruck.find(params[:id])
    end
    unless @stock_truck.nil?
      @trucks = Truck.where(:user_id =>session[:user_id], :stock_truck_id=>params[:id]).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    else
      if params[:status]=="peihuo"
        @trucks = Truck.where(:user_id =>session[:user_id], :status =>"正在配货").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
      elsif params[:status]=="ischenjiao"
        @trucks = Truck.where(:user_id =>session[:user_id], :status =>"正在成交").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
      elsif params[:status]=="chenjiao"
        @trucks = Truck.where(:user_id =>session[:user_id], :status =>"已成交").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
      else
        @trucks = Truck.where(:user_id =>session[:user_id]).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
      end
      
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @trucks }
    end
  end

  def quoteinquery
    # @truck=Truck.find(params[:truck_id])
    @truck=Truck.find(params[:truck_id])
    @baojia=Quote.where(:truck_id =>BSON::ObjectId(params[:truck_id]), :user_id =>session[:user_id])
    @xunjia=Inquery.where(:truck_id => BSON::ObjectId(params[:truck_id]))

    #  logger.info "@xunjia.size=#{@xunjia.size}"
  end
  
  def baojiatruck
    @search=Search.new
    @search.fcity_code="100000000000"
    @search.tcity_code="100000000000"
    
    @trucks=Truck.where(:from_site=>"local").desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>20)
 
   
  end
  
  def search
    @search=Search.new
    if params[:search].nil? then
      #puts "params[:search] is nil"
    
      unless params[:from].blank?
        @search.fcity_code=params[:from]
        @search.fcity_name=$city_code_name[params[:from]]
      else
        @search.fcity_code="100000000000"
        @search.fcity_name="出发地选择"
      end
      unless params[:from].blank?
        @search.tcity_code=params[:to];@search.tcity_name=$city_code_name[params[:to]] 
      else
        @search.tcity_name="到达地选择"
        @search.tcity_code="100000000000"
      end

    else
      @search.fcity_name=params[:search][:fcity_name]
      @search.tcity_name=params[:search][:tcity_name]
      @search.fcity_code=params[:search][:fcity_code]
      @search.tcity_code=params[:search][:tcity_code]
    end

    @action_suffix="#{@search.fcity_code}#{@search.tcity_code}#{params[:page]}"
  
    @search.save
    
    @trucks=get_search_truck(@search.fcity_code,@search.tcity_code)
    respond_to do |format|
      if params[:layout]     
        format.html  
      else
        format.html {render :layout=>"truck"}
      end
    end
  end
  
  def part
    @stock_truck=StockTruck.find(params[:stock_truck_id])
    @trucks=Truck.where(:stock_truck_id =>params[:stock_truck_id],:user_id =>session[:user_id]).paginate(:page=>params[:page]||1,:per_page=>20)
    respond_to do |format|
      format.html # part.html.erb
      format.xml  { render :xml => @trucks }
    end
  end

  def match
    # @truck = Truck.find(params[:truck_id])
    @truck = Truck.find(params[:truck_id])
    @search=Search.new
    @search.fcity_name=@truck.fcity_name
    @search.tcity_name=@truck.tcity_name
    @search.fcity_code=@truck.fcity_code
    @search.tcity_code=@truck.tcity_code
    
    if @search.fcity_code=="100000000000" && @search.tcity_code=="100000000000" then
      @trucks=Cargo.where(:status=>"正在配货").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    elsif @search.fcity_code=="100000000000" && @search.tcity_code!="100000000000"
      min=get_max_min_code(@search.tcity_code)[0]
      max=get_max_min_code(@search.tcity_code)[1]
      
      @trucks=Cargo.where({:tcity_code.gte=>min,:tcity_code.lt=>max,:status=>"正在配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    elsif @search.tcity_code=="100000000000" && @search.fcity_code!="100000000000"
      min=get_max_min_code(@search.fcity_code)[0]
      max=get_max_min_code(@search.fcity_code)[1]
      @trucks=Cargo.where({:fcity_code.gte =>min,:fcity_code.lt =>max,:status=>"正在配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    else
      mint=get_max_min_code(@search.tcity_code)[0]
      maxt=get_max_min_code(@search.tcity_code)[1]
      minf=get_max_min_code(@search.fcity_code)[0]
      maxf=get_max_min_code(@search.fcity_code)[1]
      @trucks=Cargo.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"正在配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    end
  
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @truck }
    end
  end

  # GET /trucks/1
  # GET /trucks/1.xml
  def show
    @user=User.find(session[:user_id]) if session[:user_id]
    Sitedatum.first.inc(:truckshow,1)
    @jubao=Jubao.new
    @jubaotype="truck"
    @fromip=request.remote_ip
    @belongid=params[:id]
    @username=@user.name if    @user
   
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @truck }
    end
  end

  # GET /trucks/new
  # GET /trucks/new.xml
  def new
    @stock_truck=StockTruck.find(params[:id])    
    @truck = Truck.new
    @user=User.find(session[:user_id])
    # @user_contact=UserContact.find_by_user_id(@user.id)
    #  @user_contact=@user.user_contact_id
    #   @company=@user.company_id
    
    @truck.stock_truck_id=@stock_truck.id
    @truck.paizhao=@stock_truck.paizhao
    @truck.dunwei=@stock_truck.dun_wei
    @truck.length=@stock_truck.che_length
    @truck.usage=@stock_truck.truck_usage
    @truck.shape=@stock_truck.truck_shape
    @truck.driver_name=@stock_truck.driver_name
    @truck.driver_phone=@stock_truck.driver_phone
    @truck.car_phone=@stock_truck.car_phone
    @truck.status="正在配货"


    @truck.user_id=@user.id
    @truck.company_id=@user.company_id
    #  @truck.user_contact_id=UserContact.find_by_user_id(@truck.user_id).id
    @truck.user_contact_id=@user.user_contact_id
   
    # @user_contact=UserContact.find_by_user_id(session[:user_id])
    #   @user_contact=@user.user_contact
    #   @truck.user_contact_id=@user_contact.id unless @user_contact.nil?

    if @user.user_contact_id.blank?
      flash[:notice]="填写更多联系方式能增加成交机会；"
      # render(:template=>"shared/new_contact")
      #  return;
    end
    # @company=Company.find_by_user_id(@user.id)
    # @truck.company_id=@company.id unless @company.nil?

    if @user.company_id.blank?
      flash[:notice]="填写公司信息能增加成交机会"
      # render(:template=>"shared/new_company")
      #  return;
    end
   
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @truck }
    end

  end

  # GET /trucks/1/edit
  def edit
    @truck = Truck.find(params[:id])
    @stock_truck=StockTruck.find(@truck.stock_truck_id)
  end

  # POST /trucks
  # POST /trucks.xml
  def create
    @user=User.find(session[:user_id])
    params[:truck][:stock_truck_id]=BSON::ObjectId( params[:truck][:stock_truck_id])
    params[:truck][:user_id]=@user.id
    params[:truck][:company_id]=@user.company_id
    params[:truck][:user_contact_id]=@user.user_contact_id

    params[:truck][:from_site]="local"
    @truck=Truck.new(params[:truck])  
    @truck.line=@truck.fcity_code+"#"+@truck.tcity_code     
 
    respond_to do |format|
      if @truck.save
        flash[:notice] = '车源创建成功'
        expire_fragment  "trucks_allcity_1"
        expire_fragment  "provincecargo"
        expire_fragment  "users_center_#{@user.id}"
        #update statistic for truck
        # Truck.collection.update({'_id' => @truck.id},{'$set' =>{:total_baojia=>0,:total_xunjia=>0,:total_match=>0,
        #    :total_click=>0}});

        @truck.update_attributes(:total_baojia=>0,:total_xunjia=>0,:total_match=>0,
          :total_click=>0,:user_id=>session[:user_id],:truck_id=>@truck.id);
        begin
          ustatistic= Ustatistic.find(@user.ustatistic_id)
        rescue
        end
        unless ustatistic.blank?
          ustatistic.update_attributes(:status=>"正在配货")
          ustatistic.inc("total_truck",1)
          ustatistic.inc("valid_truck",1)
        else
          Ustatistic.create("user_id"=>session[:user_id],:status=>"正在配货",:total_truck =>1,:valid_truck=>1)
        end
        #   Ustatistic.collection.update({'user_id' => BSON::ObjectId(session[:user_id].to_s)},{'$inc' => {"total_truck" => 1,"valid_truck"=>1},'$set' => {"status"=>"正在配货"}})
        @lstatistic=Lstatistic.where(:line=>@truck.line).first
        unless @lstatistic.blank?
          @lstatistic.inc(:total_truck,1)
          @lstatistic.inc(:valid_truck,1)
        else
          Lstatistic.create(:line=>@truck.line,:total_truck =>1,:valid_truck=>1)
        end

        #  Lstatistic.collection.update({'line'=>@truck.line},{'$inc' => {"total_truck" => 1,"valid_truck"=>1},'$set' => {"status"=>"正在配货"}},{:upsert =>true})
        #   StockTruck.collection.update({'_id' => @truck.stock_truck_id},{'$inc' => {"valid_truck" => 1,"total_truck"=>1},'$set' => {"status"=>"正在配货"}})
        @stock_truck=StockTruck.find(@truck.stock_truck_id)
        @stock_truck.update_attributes(:status=>"正在配货")
        @stock_truck.inc(:valid_truck,1)
        @stock_truck.inc(:total_truck,1)
        # @stock_truck.inc(:sent_weight,@cargo.cargo_weight.to_f)
        # @stock_truck.inc(:sent_bulk,@cargo.cargo_bulk.to_f)
        #  expire_line_truck(@truck.fcity_code,@truck.tcity_code)
        
        format.html { redirect_to :action=>"index"}
        format.xml  { render :xml => @truck, :status => :created, :location => @truck }
      else
        flash[:notice] = '车源创建失败，重复发布'
        # @stock_truck=StockTruck.find(@truck.stock_truck_id)
        format.html { render :action => "new" }
        format.xml  { render :xml => @truck.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /trucks/1
  # PUT /trucks/1.xml
  def update
    @truck = Truck.find(params[:id])
    @stock_truck=StockTruck.find(@truck.stock_truck_id)
    #  @trucks = update_truck_info_from_params(params)    
    respond_to do |format|
      if @truck.update_attributes( params[:truck])
        flash[:notice] = '货源更新成功.'
        format.html { redirect_to(@trucks) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trucks.errors, :status => :unprocessable_entity }
      end
    end
  end
  def confirm_chenjiao
    
    @user=User.find(session[:user_id])
    @truck = Truck.find(params[:id])     
    #all other truck with same paizhao , need expire also
    Truck.where(:paizhao=>@truck.paizhao).each do |truck|
      truck.update_attribute("status","已成交")
    end
    
    Quote.where(:truck_id=>@truck.id).each do |quote|
      quote.update_attribute("status","成交过期")
    end
    Inquery.where(:truck_id=>@truck.id).each do |inquery|
      inquery.update_attribute("status","成交过期")
    end
    
    @quote=Quote.where(:truck_id=>@truck.id,:status=>"请求成交").first #should be only one
    @inquery=Inquery.where(:truck_id=>@truck.id , status=>"请求成交").first#should be only one
    @quote.update_attribute("status","已成交") unless @quote.blank?
    @inquery.update_attribute("status","已成交") unless @inquery.blank?

    #need update statistics
    @ustatistic=Ustatistic.where(:user_id=>@user.id).first
    @ustatistic.inc(:valid_truck,-1) if @ustatistic.valid_truck>0
    @ustatistic.inc(:total_truck,-1) if @ustatistic.total_truck>0
    
    
    #change stocktruck to idle
    @stock_truck=StockTruck.where(:paizhao=>@truck.paizhao).first
    @stock_truck.update_attribute("status","车辆闲置")
    
    respond_to do |format|
      format.html { redirect_to(:controller=>"trucks",:action=>"index" )}
    end


  end
  # DELETE /trucks/1
  # DELETE /trucks/1.xml
  def destroy
    @truck = Truck.find(params[:id])
    @truck.destroy

    respond_to do |format|
      format.html { redirect_to(trucks_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def allcity

  end
  
  def cityfrom
    @search=Search.new;    @search.fcity_code=params[:city_id];    @search.tcity_code="100000000000"
    @province=params[:city_id].slice(0,2)+"0000000000"
    cityid=params[:city_id]
    if cityid.match(/\d\d0000000000$/) # is a province id
      next_province=cityid.to_i+10000000000
      @trucks=Truck.where(:status=>"正在配货",:fcity_code.gte=>cityid.to_s,:fcity_code.lt=> next_province.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    elsif  cityid.match(/\d\d\d\d00000000$/)  and (not cityid.match(/\d\d0000000000$/))  # is a region
      next_region=cityid.to_i+100000000
      @trucks=Truck.where(:status=>"正在配货",:fcity_code.gte=>cityid.to_s,:fcity_code.lt=> next_region.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    else
      @trucks=Truck.where(:status=>"正在配货",:fcity_code=>cityid.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    end
  end
  def cityto
    @search=Search.new;    @search.tcity_code=params[:city_id];    @search.fcity_code="100000000000"
    @province=params[:city_id].slice(0,2)+"0000000000"
    cityid=params[:city_id]
    if cityid.match(/\d\d0000000000$/) # is a province id
      next_province=cityid.to_i+10000000000
      @trucks=Truck.where(:status=>"正在配货",:tcity_code.gte=>cityid.to_s,:tcity_code.lt=> next_province.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    elsif  cityid.match(/\d\d\d\d00000000$/)  and (not cityid.match(/\d\d0000000000$/))  # is a region
      next_region=cityid.to_i+100000000
      @trucks=Truck.where(:status=>"正在配货",:tcity_code.gte=>cityid.to_s,:tcity_code.lt=> next_region.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    else
      @trucks=Truck.where(:status=>"正在配货",:tcity_code=>cityid.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    end
    
  end

  def city
    city_level(params[:city_id]) #for title usage , SEO friendlly
  end
  
end
