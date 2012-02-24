#coding: utf-8
class CitiesController < ApplicationController
  # GET /cities
  # GET /cities.xml
  include CitiesHelper
  include CompaniesHelper
  caches_page :index
  #   expire_page :action => :index
  layout :choose_layout 
  
  def choose_layout
    return "cargo"  if action_name =='mapcity'   ||    action_name =='mapline'
    return nil     
  end
  
  def index
    #  puts "city action index happen dir=#{params[:dir]}"
    #get the original value
    if params[:dir]=="from"
      code=params[:code] ||( params[:search][:fcity_code] unless params[:search].nil?)
    elsif  params[:dir]=="to"
      code=params[:code] || (params[:search][:tcity_code] unless params[:search].nil?)
    end       
    
    if code.nil? || code=="100000000000"
      code="330100000000" #default open ZheJiang Province
      # puts "code is nil !!!"
    end    
    @code=code
    @selected_city_code=code  

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cities }
    end
    #  puts "finish city action index happen for dir=#{params[:dir]}"
  end

  # GET /cities/1
  # GET /cities/1.xml
  def show
    @city = City.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /cities/new
  # GET /cities/new.xml
  def new
    @city = City.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /cities/1/edit
  def edit
    @city = City.find(params[:id])
  end

  # POST /cities
  # POST /cities.xml
  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        format.html { redirect_to(@city, :notice => 'City was successfully created.') }
        format.xml  { render :xml => @city, :status => :created, :location => @city }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cities/1
  # PUT /cities/1.xml
  def update
    @city = City.find(params[:id])

    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to(@city, :notice => 'City was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def modal
    @city_code=params[:code]
    @fcity_code=params[:fcode]
    @tcity_code=params[:tcode]
    @companies= get_search_companies(params[:code])
    
  end
  
  def mapcity
    @city_code=params[:code]
    city=City.where(:code=> @city_code).first
    @city_name=city.name
    unless city.nil?
      @lng=city.loc[0]
      @lat=city.loc[1]
      @markers = "[
             {'description': 'Hi', 'title': 'test', 'sidebar': '', 'lng': #{@lng}, 'lat': #{@lat}, 'picture': '', 'width': '940', 'height': '800'},
             {'lng': #{@lng}, 'lat': #{@lat} }
            ]"
    end   
     
  end
  
  def mapline
    @fcity_code=params[:fcode]
    @tcity_code=params[:tcode]
    @fcity=City.where(:code=> @fcity_code).first
    @tcity=City.where(:code=> @tcity_code).first
    @fcity_full_name=get_city_full_name(params[:fcode])
    @tcity_full_name=get_city_full_name(params[:tcode])
  end
  
 
  
  # DELETE /cities/1
  # DELETE /cities/1.xml
  def destroy
    @city = City.find(params[:id])
    @city.destroy

    respond_to do |format|
      format.html { redirect_to(cities_url) }
      format.xml  { head :ok }
    end
  end
end
