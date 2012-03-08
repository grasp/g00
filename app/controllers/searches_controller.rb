# coding: utf-8
class SearchesController < ApplicationController
  # GET /searches
  # GET /searches.xml
# layout "public",:except=>[:create]
  layout:nil
  def index
    @searches = Search.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @searches }
    end
  end

  # GET /searches/1
  # GET /searches/1.xml
  def show
    @search = Search.find(params[:id])   
 # to stop show old search,dangrous ,due ro many people search , id many increae then 10
    if params[:id].to_i >=Search.maximum('id')
    
    @line_ad=LineAd.find_by_line("0")
    @line_ad.fcity_name=@search.fcity_name
    @line_ad.tcity_name=@search.tcity_name
    
    if  @search.fcity_code.size<1 && @search.tcity_code.size<1
        @search.fcity_name=nil
        @search.tcity_name=nil
        @cargos = Cargo.paginate :page=>params[:page] if @search.stype=="cargos"
        @trucks = Truck.paginate :page=>params[:page] if @search.stype=="trucks"
    elsif @search.fcity_code.size<1 && @search.tcity_code.size>1
       @search.fcity_name=nil
       @cargos=Cargo.where(:tcity_code =>@search.tcity_code) if @search.stype=="cargos"
       @trucks=Truck.where( :tcity_code => @search.tcity_code) if @search.stype=="trucks"
    elsif @search.tcity_code.size<1 && @search.fcity_code.size>1
       @search.tcity_name=nil
       @cargos=Cargo.where(:fcity_code =>@search.fcity_code) if @search.stype=="cargos"
       @trucks=Truck.where(:fcity_code =>@search.fcity_code) if @search.stype=="trucks"
    else
       @cargos=Cargo.where( :fcity_code =>@search.fcity_code,:tcity_code=>@search.tcity_code) if @search.stype=="cargos"
       @trucks=Truck.where( :fcity_code =>@search.fcity_code,:tcity_code=>@search.tcity_code) if @search.stype=="trucks"
    end

  end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @search }
    end    
  end

  # GET /searches/new
  # GET /searches/new.xml
  def new
    
    @search = Search.new
    @line_ad=LineAd.find_by_line("0")
    @search.stype=params[:stype]||"cargos"
    @search.user_id=params[:user_id]||"public"

    # this is for first time search
    if@search.stype=="cargos"
     @cargos = Cargo.paginate :page=>params[:page]
     @trucks=nil
    end
    
    if @search.stype=="trucks"
      @trucks = Truck.paginate :page=>params[:page]
      @cargos=nil
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  {render :xml => @search }
    end
  end

  # GET /searches/1/edit
  def edit
    @search = Search.find(params[:id])    
  end

  # POST /searches
  # POST /searches.xml
  def create
     @search = Search.new(params[:search])     
     @line_ad=LineAd.find_by_line("0")
     @line_ad.fcity_name=@search.fcity_name
     @line_ad.tcity_name=@search.tcity_name
    
    respond_to do |format|
      if @search.save        
         format.html {redirect_to(@search)}
        # format.html { render :action => "new"}
         format.xml  { render :xml => @search, :status => :created, :location => @search }
      else
        format.html { render :action => "new"}
        format.xml  { render :xml => @search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /searches/1
  # PUT /searches/1.xml
  def update
    @search = Search.new(params[:search])
    
    @line_ad=LineAd.find_by_line( get_line(@search.fcity_code,@search.tcity_code))
    
    if @line_ad.nil?
     @line_ad=LineAd.find_by_line("0")
     @line_ad.fcity_name=@search.fcity_name
     @line_ad.tcity_name=@search.tcity_name
    end
    
    respond_to do |format|
      if @search.save
        format.html { redirect_to(@search, :notice => 'Search was successfully updated.') }
      #  format.html { redirect_to(@search, :action=>"new",:notice => 'Search was successfully updated.') }
      # format.html { render(:action=>"new",:notice => 'redirect to new.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.xml
  def destroy
    @search = Search.find(params[:id])
    @search.destroy

    respond_to do |format|
      format.html { redirect_to(searches_url) }
      format.xml  { head :ok }
    end
  end
end
