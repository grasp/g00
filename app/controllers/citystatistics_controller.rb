class CitystatisticsController < ApplicationController
  # GET /citystatistics
  # GET /citystatistics.xml
  def index
    @citystatistics = Citystatistic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @citystatistics }
    end
  end

  # GET /citystatistics/1
  # GET /citystatistics/1.xml
  def show
    @citystatistic = Citystatistic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @citystatistic }
    end
  end

  # GET /citystatistics/new
  # GET /citystatistics/new.xml
  def new
    @citystatistic = Citystatistic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @citystatistic }
    end
  end

  # GET /citystatistics/1/edit
  def edit
    @citystatistic = Citystatistic.find(params[:id])
  end

  # POST /citystatistics
  # POST /citystatistics.xml
  def create
    @citystatistic = Citystatistic.new(params[:citystatistic])

    respond_to do |format|
      if @citystatistic.save
        format.html { redirect_to(@citystatistic, :notice => 'Citystatistic was successfully created.') }
        format.xml  { render :xml => @citystatistic, :status => :created, :location => @citystatistic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @citystatistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /citystatistics/1
  # PUT /citystatistics/1.xml
  def update
    @citystatistic = Citystatistic.find(params[:id])

    respond_to do |format|
      if @citystatistic.update_attributes(params[:citystatistic])
        format.html { redirect_to(@citystatistic, :notice => 'Citystatistic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @citystatistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /citystatistics/1
  # DELETE /citystatistics/1.xml
  def destroy
    @citystatistic = Citystatistic.find(params[:id])
    @citystatistic.destroy

    respond_to do |format|
      format.html { redirect_to(citystatistics_url) }
      format.xml  { head :ok }
    end
  end
end
