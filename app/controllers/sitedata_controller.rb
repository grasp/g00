class SitedataController < ApplicationController
  # GET /sitedata
  # GET /sitedata.xml
  layout "admin"
  def index
    @sitedata = Sitedatum.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sitedata }
    end
  end

  # GET /sitedata/1
  # GET /sitedata/1.xml
  def show
    @sitedatum = Sitedatum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sitedatum }
    end
  end

  # GET /sitedata/new
  # GET /sitedata/new.xml
  def new
    @sitedatum = Sitedatum.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sitedatum }
    end
  end

  # GET /sitedata/1/edit
  def edit
    @sitedatum = Sitedatum.find(params[:id])
  end

  # POST /sitedata
  # POST /sitedata.xml
  def create
    @sitedatum = Sitedatum.new(params[:sitedatum])

    respond_to do |format|
      if @sitedatum.save
        format.html { redirect_to(@sitedatum, :notice => 'Sitedatum was successfully created.') }
        format.xml  { render :xml => @sitedatum, :status => :created, :location => @sitedatum }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sitedatum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sitedata/1
  # PUT /sitedata/1.xml
  def update
    @sitedatum = Sitedatum.find(params[:id])

    respond_to do |format|
      if @sitedatum.update_attributes(params[:sitedatum])
        format.html { redirect_to(@sitedatum, :notice => 'Sitedatum was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sitedatum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sitedata/1
  # DELETE /sitedata/1.xml
  def destroy
    @sitedatum = Sitedatum.find(params[:id])
    @sitedatum.destroy

    respond_to do |format|
      format.html { redirect_to(sitedata_url) }
      format.xml  { head :ok }
    end
  end
end
