# coding: utf-8

class CargosController < ApplicationController
  # include Soku
  # GET /cargos
  # GET /cargos.xml
  include CargosHelper
  #before_filter:authorize, :except => [:search,:show,:baojiacargo]
  before_filter:authorize, :only => [:new,:create,:update,:destroy,:edit,:quoteinquery,:request_chenjiao,:cargo_to_friend,:send_cargo_myself]
  # before_filter:authorize_public, :only => [:search]
  # caches_page :search,:show
  caches_page :controller => "cargos_controller", :action => "city"
  protect_from_forgery :except => [:tip,:login,:post_cargo]
  # layout 'cargo' ,:except => [:show,:search]
  #layout 'cargo' ,:except => [:show]
  #
  layout :choose_layout   
  def choose_layout
    return nil  if action_name =='post_cargo'     
    return 'usercenter'  if action_name =='index'      
    return  nil if  action_name=="show" ||action_name=="send_cargo_myself"||action_name=="cargo_to_friend"
    return "usercenter" if action_name=="new"
    return 'cargo'
  end
  
  def quickfabu
    fabu_helper    
    respond_to do |format|
      format.html {render :flash=>{:notice=>flash[:notice],:from=>flash[:from],
          :to=>flash[:to],:contact=>flash[:contact],:cargoname=>flash[:cargoname],:chelength=>flash[:chelength],:comments=>flash[:comments],
          :send_date=>flash[:send_date],:weight=>flash[:weight],:zuhuo=>flash[:zuhuo]}}
      #   format.xml  { render :xml => @cargo }
    end
    
  end
  def public
    #if this is all    
    if params[:city_from].nil?
      @cargos = Cargo.paginate(:page=>params[:page]||1,:per_page=>25)
    else
      @cargos=nil
    end
    # if this is line search
    #render view here
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargo }
    end
  end
  def baojiacargo
    @search=Search.new
    @search.fcity_code="100000000000"
    @search.tcity_code="100000000000"
    
    @cargos=Cargo.where(:from_site=>"local").desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
 
  end
  def search  
    search_helper
  end

  def quoteinquery
    # @cargo=Cargo.find(params[:cargo_id])
    @cargo=Cargo.find(params[:cargo_id])
    @xunjia=Inquery.where(:cargo_id => params[:cargo_id])
    @baojia=Quote.where(:cargo_id => params[:cargo_id])
  end
  
  def index

    unless params[:stock_cargo_id].blank?
      @cargos=Cargo.where({:user_id =>session[:user_id], :stock_cargo_id =>params[:stock_cargo_id]}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    else
      if params[:status]=="peiche"
        @cargos = Cargo.where(:user_id =>session[:user_id],:status =>"正在配车").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
      elsif params[:status]=="ischenjiao"
        @cargos = Cargo.where(:user_id =>session[:user_id],:status =>"正在成交").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
      elsif params[:status]=="chenjiao"
        @cargos = Cargo.where(:user_id =>session[:user_id],:status =>"已成交").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
      else
        #@cargos = Cargo.where("user_id = ?",session[:user_id]).order("updated_at desc").paginate(:page=>params[:page]||1,:per_page=>25)
        @cargos = Cargo.where(:user_id =>session[:user_id]).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
      end
    end
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargos }
    end   
  end
  
  def match
    #  @cargo = Cargo.find(params[:cargo_id])
    @cargo = Cargo.find(params[:cargo_id])
    @search=Search.new
    @search.fcity_name=@cargo.fcity_name
    @search.tcity_name=@cargo.tcity_name
    @search.fcity_code=@cargo.fcity_code
    @search.tcity_code=@cargo.tcity_code
      
    # @trucks=Truck.where(:fcity_code =>@cargo.fcity_code,:tcity_code =>@cargo.tcity_code).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    if @search.fcity_code=="100000000000" && @search.tcity_code=="100000000000" then   
      @trucks=Truck.where.desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    elsif @search.fcity_code=="100000000000" && @search.tcity_code!="100000000000"
      min=get_max_min_code(@search.tcity_code)[0]
      max=get_max_min_code(@search.tcity_code)[1]
      @trucks=Truck.where({:tcity_code.gte=>min,:tcity_code.lt=>max,:status=>"配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    elsif @search.tcity_code=="100000000000" && @search.fcity_code!="100000000000"
      min=get_max_min_code(@search.fcity_code)[0]
      max=get_max_min_code(@search.fcity_code)[1]
      @trucks=Truck.where({:fcity_code.gte =>min,:fcity_code.lt =>max,:status=>"配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    else
      mint=get_max_min_code(@search.tcity_code)[0]
      maxt=get_max_min_code(@search.tcity_code)[1]
      minf=get_max_min_code(@search.fcity_code)[0]
      maxf=get_max_min_code(@search.fcity_code)[1]
      @trucks=Truck.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    end
    @search.save
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargo }
    end

  end

  def part
    # @stock_cargo = StockCargo.find(params[:stock_cargo_id])
    @stock_cargo = StockCargo.find(params[:stock_cargo_id])
    @cargos=Cargo.where({:stock_cargo_id => params[:stock_cargo_id],:user_id =>session[:user_id]}).paginate(:page=>params[:page]||1,:per_page=>25)
    respond_to do |format|
      format.html # part.html.erb
      format.xml  { render :xml => @cargos }
    end
  end
  # GET /cargos/1
  # GET /cargos/1.xml
  def show
    @error=false
    begin
      @cargo=Cargo.find(params[:id])
    rescue
      @error=true
    end
    if not @error
      #for jubao purpose
      @user=User.find(session[:user_id]) if session[:user_id]
      #update site statistic here
      Sitedatum.first.inc(:cargoshow,1)
     
      @jubao=Jubao.new
      @jubaotype="cargo"
      @fromip=request.remote_ip
      @belongid=params[:id]
      @username=@user.name if  @user     
      @wmail=Wmail.new
 
      @wmail.subject="物流零距离货源信息-#{@cargo.fcity_name}-#{@cargo.tcity_name}-#{@cargo.created_at.to_s.slice(0,19)}"
      @wmail.mailtype="cargo_myself"
    
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @cargo }
      end
    else
      respond_to do |format|
        format.html { render "cargos/showerror"} # show.html.erb
        format.xml  { render :xml => @cargo }
      end
    end
  end

  # GET /cargos/new
  # GET /cargos/new.xml
  def new
    #check conact first
    @cargo = Cargo.new
    @stock_cargo=StockCargo.find(BSON::ObjectId(params[:id]))
    @cargo .stock_cargo_id=@stock_cargo.id
    @user=User.find(session[:user_id])

    @cargo.user_id=@user.id
    @cargo.status="正在配车"
    @cargo.stock_cargo_id=@stock_cargo.id
    if false
      if @user.user_contact_id.blank?
        flash[:notice]="填写更多的联系信息，可以增加成交机会"
      end
      if @user.company_id.blank?
        if flash[:notice].blank?
          flash[:notice]="填写公司信息能够增加成交机会"
        else
          flash[:notice]<<";填写公司信息能够增加成交机会"
        end

      end
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cargo }
    end

  end

  # GET /cargos/1/edit
  def edit
    @cargo = Cargo.find(params[:id])
    if @cargo.nil?
      puts "你编辑了一个空的"
    end
    # @stock_cargo=StockCargo.find(@cargo.stock_cargo_id)
    @stock_cargo=@cargo.stock_cargo

  end

  # POST /cargos
  # POST /cargos.xml
  def create
    params[:cargo][:from_site]="local"
    params[:cargo][:priority]=100

    params[:cargo][:stock_cargo_id]=BSON::ObjectId(params[:cargo][:stock_cargo_id])
    @user=User.find(session[:user_id])
   
    #update cargo phone information for concerncargo
    params[:cargo][:mobilephone]=@user.mobilephone        
    user_contact=UserContact.find(@user.user_contact_id) unless @user.user_contact_id .nil?
    
    unless user_contact.blank?
      params[:cargo][:user_contact_id]= user_contact.id 
      params[:cargo][:fixphone]=user_contact.quhao+"-"+user_contact.fixphone
    end
    
    @cargo=Cargo.new(params[:cargo])
    @cargo.company_id=Company.find(@user.company_id) unless @user.company_id .nil?
    @cargo.user_id=@user.id
    @cargo.line=@cargo.fcity_code+"#"+@cargo.tcity_code


    respond_to do |format|
      if @cargo.save
        flash[:notice] = '创建货源成功！'

        @cargo.update_attributes(:total_baojia=>0,:total_xunjia=>0,:total_match=>0,
          :total_click=>0,:user_id=>session[:user_id],:cargo_id=>@cargo.id);
        #update statistic for cargo
        #update need use mongo way to avoid use model method
        #be carefull when use foreign object_id,otherwise ,will not update !!!!
        #  Ustatistic.collection.update({:user_id => BSON::ObjectId(session[:user_id].to_s)}, {'$set' => {:status=>"正在配车"}})
        # Ustatistic.collection.update({:user_id => BSON::ObjectId(session[:user_id].to_s)},{'$inc' => {:total_cargo =>1,:valid_cargo=>1}})
        begin
          ustatistic= Ustatistic.find(  @user.ustatistic_id)
        rescue
        end
        unless ustatistic.blank?
          logger.info  "inc cargo ustatisc"
          ustatistic.update_attributes(:status=>"正在配车")
          ustatistic.inc(:total_cargo,1)
          ustatistic.inc(:valid_cargo,1)
        else
          Ustatistic.create("user_id"=>session[:user_id],:status=>"正在配车",:total_cargo =>1,:valid_cargo=>1)
          logger.info  "create ustatisc for cargo create"
        end
        # Lstatistic.collection.update({:line=>@cargo.line},{'$set' =>{:status=>"正在配车"}});
        # Lstatistic.collection.update({:line=>@cargo.line},{'$inc' => {:total_cargo =>1,:valid_cargo=>1}})
        @lstatistic=Lstatistic.where(:line=>@cargo.line).first
        unless @lstatistic.nil?
          @lstatistic.inc(:total_cargo,1)
          @lstatistic.inc(:valid_cargo,1)
        else
          Lstatistic.create(:line=>@cargo.line,:total_cargo =>1,:valid_cargo=>1)
        end
      
        
        #$inc and $set could not be used together !!!!!!!???
        # $db[:stock_cargos].update({'_id' => @cargo.stock_cargo_id},{'$inc' =>{"valid_cargo" =>1},'$set' =>{"status"=>"正在配车"}})
        # StockCargo.collection.update({:_id => @cargo.stock_cargo_id},{'$set' =>{:status=>"正在配车"}})
        @stock_cargo=StockCargo.find(@cargo.stock_cargo_id)
        @stock_cargo.update_attributes(:status=>"正在配车")
        @stock_cargo.inc(:valid_cargo,1)
        @stock_cargo.inc(:total_cargo,1)
        @stock_cargo.inc(:sent_weight,@cargo.cargo_weight.to_f)
        @stock_cargo.inc(:sent_bulk,@cargo.cargo_bulk.to_f)
       
        # StockCargo.collection.update({:_id => @cargo.stock_cargo_id},
        #  {'$inc'=>{:valid_cargo=>1,:total_cargo=>1,:sent_weight=>@cargo.cargo_weight.to_f,:sent_bulk=>@cargo.cargo_bulk.to_f}},{:upsert =>true})
      
        format.html { redirect_to :action => "index"}
        #  format.xml  { render :xml => @cargo, :status => :created, :location => @cargo }
      else
        flash[:notice] = '创建货源失败,重复发布货源'
        # @stock_cargo=StockCargo.find(@cargo.stock_cargo_id)
        format.html { render :template=>"/cargos/repeat_error" }
        format.xml  { render :xml => @cargo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cargos/1
  # PUT /cargos/1.xml
  def update
    
    @cargo = Cargo.find(params[:id])
    @stock_cargo=StockTruck.find(@cargo.stock_cargo_id)

    #  @cargo =update_cargo_info_from_params(params)
    expire_fragment "users_center_#{session[:user_id]}"
    respond_to do |format|
      #update may fail due to
      if   @cargo.update_attributes( params[:cargo])
        flash[:notice] = '货源更新成功'
        format.html { redirect_to(@cargo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cargo.errors, :status => :unprocessable_entity }
      end
    end
  end

  def request_chenjiao
    @user=User.find(session[:user_id])
    @cargo = Cargo.find(params[:id])



    @cargo.update_attribute("status","请求成交")


    Quote.where(:cargo_id=>@cargo.id).each do |quote|
      quote.update_attribute("status","成交过期")
    end
    Inquery.where(:cargo_id=>@cargo.id).each do |inquery|
      inquery.update_attribute("status","成交过期")
    end

    @quote=Quote.where(:cargo_id=>@cargo.id,:status=>"成交过期").first #should be only one
    @inquery=Inquery.where(:cargo_id=>@cargo.id , :status=>"成交过期").first#should be only one
    @quote.update_attribute("status","请求成交") unless @quote.blank?
    @inquery.update_attribute("status","请求成交") unless @inquery.blank?

    @ustatistic=Ustatistic.where(:user_id=>@user.id).first
    @ustatistic.inc(:valid_cargo,-1) if @ustatistic.valid_cargo>0
    @ustatistic.inc(:total_cargo,-1) if @ustatistic.total_cargo>0


    #change stockcargo to idle
    @stock_cargo=StockCargo.find(@cargo.stock_cargo_id)
    @stock_cargo.update_attribute("status","请求成交")

    respond_to do |format|
      format.html { redirect_to(:controller=>"cargos",:action=>"index" )}
    end
  end

  # DELETE /cargos/1
  # DELETE /cargos/1.xml
  def destroy
    cargo = Cargo.find(BSON::ObjectId(params[:id]))
    cargo.delete if cargo

    #do we need update the statisitc?
    # url=request.url
    @user=User.find(session[:user_id])
    respond_to do |format|
      if @user.name=="admin"
        format.html { redirect_to(admincargo_manage_path) }
      else
        format.html { redirect_to(root_path) }
      end
      format.xml  { head :ok }
    end
  end


  def allcity

    if params[:from]=="mail"
      Sitedatum.first.inc(:from_mail,1)
      redirect_to(root_path)
    end
  
    # respond_to do |format|
    #    format.html # index.html.erb
    #    format.mobile
    #  end

  end
  
  def cityfrom
    @search=Search.new;    @search.fcity_code=params[:city_id];    @search.tcity_code="100000000000"
    @province=params[:city_id].slice(0,2)+"0000000000"
    cityid=params[:city_id]
    if cityid.match(/\d\d0000000000$/) # is a province id
      next_province=cityid.to_i+10000000000
      @cargos=Cargo.where(:status=>"正在配车",:fcity_code.gte=>cityid.to_s,:fcity_code.lt=> next_province.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    elsif cityid.match(/\d\d\d\d00000000$/)  and (not cityid.match(/\d\d0000000000$/))  # is a region
      next_region=cityid.to_i+100000000
      @cargos=Cargo.where(:status=>"正在配车",:fcity_code.gte=>cityid.to_s,:fcity_code.lt=> next_region.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    else
      @cargos=Cargo.where(:status=>"正在配车",:fcity_code=>cityid.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    end
    
  end
  def cityto
    @search=Search.new;    @search.tcity_code=params[:city_id];    @search.fcity_code="100000000000"
    @province=params[:city_id].slice(0,2)+"0000000000"
    cityid=params[:city_id]
    if cityid.match(/\d\d0000000000$/) # is a province id
      next_province=cityid.to_i+10000000000
      @cargos=Cargo.where(:status=>"正在配车",:tcity_code.gte=>cityid.to_s,:tcity_code.lt=> next_province.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    
    elsif  cityid.match(/\d\d\d\d00000000$/)  and (not cityid.match(/\d\d0000000000$/))  # is a region
      next_region=cityid.to_i+100000000
      @cargos=Cargo.where(:status=>"正在配车",:tcity_code.gte=>cityid.to_s,:tcity_code.lt=> next_region.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    else
      @cargos=Cargo.where(:status=>"正在配车",:tcity_code=>cityid.to_s)
      .desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>25)
    end
    
  end

  def city
    city_level(params[:city_id]) #for title usage , SEO friendlly
  end
  
  def send_cargo_myself
    #not allow user send too much email in one day
    @user=User.find(session[:user_id])
    @today_total=Wmail.where(:from=>@user.email,:created_at.gte=>Time.now.at_beginning_of_day).count
    if ((session[:user_id] && @today_total<=10) || @user.email=="mark.xiansheng@gmail.com" )
      @wmail=Wmail.new

      cargo_show_helper
      @wmail.from=@user.email
      @wmail.to=@user.email
      @wmail.subject="物流零距离货源信息-#{@cargo.fcity_name}-#{@cargo.tcity_name}-#{@cargo.created_at.to_s.slice(0,19)}"
      @wmail.mailtype="cargo_myself"
      begin
        Notifier.send_cargo_myself(@user,@cargo,@contact).deliver!
        @result="成功发送,今日已发送#{@today_total+1}/10"
        @wmail.save
      rescue
        @result="发送失败,今日已发送#{@today_total}/10"
      end
    else
      @result="无效发送,今日已发送#{@today_total}/10"
    end
  end
  
  def new_send_cargo_to_friend
    
  end
  
  def cargo_to_friend
    #not allow user send too much email in one day
    @user=User.find(session[:user_id])
    @today_total=Wmail.where(:from=>@user.email,:created_at.gte=>Time.now.at_beginning_of_day).count
    if ((session[:user_id] && @today_total<=10) || @user.email=="mark.xiansheng@gmail.com" )
      @wmail=Wmail.new
      params[:id]=params[:wmail][:cargo_id]
      cargo_show_helper
      @wmail.from=@user.email
      @wmail.to=params[:wmail][:to] #need verify the email valid
      @wmail.subject="物流零距离货源信息-#{@cargo.fcity_name}-#{@cargo.tcity_name}-#{@cargo.created_at.to_s.slice(0,19)}"
      @wmail.mailtype="cargo_friend"
      begin
        Notifier.send_cargo_friend(@user,@cargo,@contact,params[:wmail][:to].split(";")).deliver!
        @result="成功发送,今日已发送#{@today_total+1}/10"
        @wmail.save
      rescue
        @result="发送失败,今日已发送#{@today_total}/10"
      end
    else
      @result="无效发送,今日已发送#{@today_total}/10"
    end
    
  end
  
  def post_cargo
    logger.info "params[:cargo]="+params[:cargo]
    new_cargo= eval(params[:cargo]).to_hash  
       
    @cargo=Cargo.new( new_cargo)
    begin
      @cargo.save!
    rescue
      logger.info "repeated cargo!"
    end
  end

end
