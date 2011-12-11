class UstatisticsController < ApplicationController
  # GET /ustatistics
  # GET /ustatistics.xml
  def index
    @ustatistics = Ustatistic.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ustatistics }
    end
  end

  # GET /ustatistics/1
  # GET /ustatistics/1.xml
  def show
    @ustatistic = Ustatistic.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ustatistic }
    end
  end

  # GET /ustatistics/new
  # GET /ustatistics/new.xml
  def new
    @ustatistic = Ustatistic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ustatistic }
    end
  end

  # GET /ustatistics/1/edit
  def edit
    @ustatistic = Ustatistic.find(params[:id])
  end

  # POST /ustatistics
  # POST /ustatistics.xml
  def create
    @ustatistic = Ustatistic.new(params[:ustatistic])
    respond_to do |format|
      if @ustatistic.save
        format.html { redirect_to(@ustatistic, :notice => 'Ustatistic was successfully created.') }
        format.xml  { render :xml => @ustatistic, :status => :created, :location => @ustatistic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ustatistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ustatistics/1
  # PUT /ustatistics/1.xml
  def update
    @ustatistic = Ustatistic.find(params[:id])

    respond_to do |format|
      if @ustatistic.update_attributes(params[:ustatistic])
        format.html { redirect_to(@ustatistic, :notice => 'Ustatistic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ustatistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ustatistics/1
  # DELETE /ustatistics/1.xml
  def destroy
    @ustatistic = Ustatistic.find(params[:id])
    @ustatistic.destroy

    respond_to do |format|
      format.html { redirect_to(ustatistics_url) }
      format.xml  { head :ok }
    end
  end
end
