#coding:utf-8
class UserlinesController < ApplicationController
  include CitiesHelper
  # GET /userlines
  # GET /userlines.xml
    before_filter:authorize, :only => [:new,:create,:update,:destroy,:edit,:myline]
  layout :choose_layout
  def choose_layout
    return "userlines" if action_name=="index" ||action_name=="city"||action_name=="cityfrom"||action_name=="cityto"
    return "usercenter" if action_name=="new" ||action_name=="myline"
    return nil
  end
  
  def index
      @search=Search.new
     @userlines = Userline.all.desc(:created_at)
      .paginate(:page=>params[:page]||1,:per_page=>25)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @userlines }
    end
  end
  def myline
    @search=Search.new
         @userlines = Userline.where(:user_id =>session[:user_id])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @userlines }
    end
  end

  # GET /userlines/1
  # GET /userlines/1.xml
  def show
    @userline = Userline.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @userline }
    end
  end

  # GET /userlines/new
  # GET /userlines/new.xml
  def new
    
    @can_create=false
    linecount=Userline.where(:user_id=>session[:user_id]).count
    @can_create=true if linecount<10
    
    @userline = Userline.new
if @can_create
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @userline }
    end
else
  respond_to do |format|
  
        format.html { render :template=>'/userlines/createfail',:layout=>"usercenter" }
  end
end
  end

  # GET /userlines/1/edit
  def edit
    @userline = Userline.find(params[:id])
  end

  # POST /userlines
  # POST /userlines.xml
  def create
    @can_create=false
    linecount=Userline.where(:user_id=>session[:user_id]).count
    @can_create=true if linecount<=10
    @userline = Userline.new(params[:userline])
     @wrong_city=false
     if params[:userline][:fcityid]=="100000000000"|| params[:userline][:tcityid]=="100000000000"
       @wrong_city=true
     end
    respond_to do |format|
      if @can_create==true && @wrong_city==false
        #get full name of city to store
        @userline.fcityname=get_city_full_name(@userline.fcityid)
        @userline.tcityname=get_city_full_name(@userline.tcityid)
       if @userline.save         
       expire_fragment "userlines_city_navi"
        expire_fragment "userlines_all"
       # format.html { redirect_to(@userline, :notice => '专线创建成功') }
       # format.html { render '/userlines/createsucc') }
       format.html { render :template=>'/userlines/createsucc',:layout=>"usercenter" }   
       else
               format.html { render :template=>'/userlines/createfail',:layout=>"usercenter" }     
       end
     #   format.xml  { render :xml => @userline, :status => :created, :location => @userline }
      else
      format.html { render :template=>'/userlines/createfail',:layout=>"usercenter" }
       # format.html { render :action => "new" }
       # format.xml  { render :xml => @userline.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /userlines/1
  # PUT /userlines/1.xml
  def update
    @userline = Userline.find(params[:id])

    respond_to do |format|
      if @userline.update_attributes(params[:userline])
        format.html { redirect_to(@userline, :notice => 'Userline was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @userline.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /userlines/1
  # DELETE /userlines/1.xml
  def destroy
    @userline = Userline.find(params[:id])
    if @userline.user_id==session[:user_id].to_s #only userself can destroy
      @userline.destroy
    end
     @userlines = Userline.where(:user_id =>session[:user_id])
     expire_fragment "userlines_city_navi"
     expire_fragment "userlines_all"
    respond_to do |format|
       format.html { render :template=>'/userlines/myline',:layout=>"usercenter" }
      format.xml  { head :ok }
    end
  end
  
  
  def allcity
        @search=Search.new;    @search.fcity_code="100000000000";    @search.tcity_code="100000000000"
       @userlines=Userlines.all.desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
  end
  def cityfrom
    @search=Search.new;    @search.fcity_code=params[:city_id];    @search.tcity_code="100000000000"
    @province=params[:city_id].slice(0,2)+"0000000000"
    cityid=params[:city_id]
    if cityid.match(/\d\d0000000000$/) # is a province id
      next_province=cityid.to_i+10000000000
      @userliness=Userlines.where(:fcityid.gte=>cityid.to_s,:fcityid.lt=> next_province.to_s)
      .desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    end
    if  cityid.match(/\d\d\d\d00000000$/)  and (not cityid.match(/\d\d0000000000$/))  # is a region
      next_region=cityid.to_i+100000000
      @userlines=Userline.where(:fcityid.gte=>cityid.to_s,:fcityid.lt=> next_region.to_s)
      .desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    end
  end
  def cityto
     @search=Search.new;    @search.tcity_code=params[:city_id];    @search.fcity_code="100000000000"
    @province=params[:city_id].slice(0,2)+"0000000000"
    cityid=params[:city_id]
    if cityid.match(/\d\d0000000000$/) # is a province id
      next_province=cityid.to_i+10000000000
      @userlines=Userline.where(:tcityid.gte=>cityid.to_s,:tcityid.lt=> next_province.to_s)
      .desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    end    
    if  cityid.match(/\d\d\d\d00000000$/)  and (not cityid.match(/\d\d0000000000$/))  # is a region
      next_region=cityid.to_i+100000000
      @userlines=Userline.where(:tcityid.gte=>cityid.to_s,:tcityid.lt=> next_region.to_s)
      .desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    end
    
  end

  def city
      city_level(params[:city_id]) #for title usage , SEO friendlly
     @search=Search.new;    @search.fcity_code=params[:city_id];    @search.tcity_code="100000000000"
  
    cityid=params[:city_id]
    
    if @province and @region.blank? and @city.blank? # is a province id
      next_province=cityid.to_i+10000000000
      @userlines = Userline.any_of([{:tcityid.gte=>cityid.to_s,:tcityid.lt=> next_province.to_s},
          {:fcityid.gte=>cityid.to_s,:fcityid.lt=> next_province.to_s}]).desc(:created_at)
      .paginate(:page=>params[:page]||1,:per_page=>25)
      
    elsif   @province and @region and @city.blank?  # is a region
      @region=params[:city_id]
       next_region=cityid.to_i+100000000
       @userlines=Userline.any_of([{:tcityid.gte=>cityid.to_s,:tcityid.lt=> next_region.to_s},
          {:fcityid.gte=>cityid.to_s,:fcityid.lt=> next_region.to_s}]).desc(:created_at)
      .paginate(:page=>params[:page]||1,:per_page=>25)
    else
     @region=params[:city_id].slice(0,4)+"00000000"
    @userlines=Userline.any_of([{:tcityid=>cityid.to_s},
          {:fcityid=>cityid.to_s}]).desc(:created_at)
      .paginate(:page=>params[:page]||1,:per_page=>25)
    end
    
    if @region
      @region_list=Array.new
      $citytree[@province][@region].each do |code,name|
        count=Userline.any_of([{:tcityid=>code.to_s},
          {:fcityid=>code.to_s}]).count
        @region_list<<[code,name,count]
      end
      #add region statistic here
          count=Userline.any_of([{:tcityid=>@region.to_s},
          {:fcityid=>@region.to_s}]).count
        @region_list<<[@region,$city_code_name[@region],count]
         @region_list.sort_by!{|x| x[2]}.reverse!
    end
  end
end
