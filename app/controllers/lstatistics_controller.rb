class LstatisticsController < ApplicationController
  # GET /lstatistics
  # GET /lstatistics.xml
  def index
    @lstatistics = Lstatistic.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lstatistics }
    end
  end

  # GET /lstatistics/1
  # GET /lstatistics/1.xml
  def show
    @lstatistic = Lstatistic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lstatistic }
    end
  end

  # GET /lstatistics/new
  # GET /lstatistics/new.xml
  def new
    @lstatistic = Lstatistic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lstatistic }
    end
  end

  # GET /lstatistics/1/edit
  def edit
    @lstatistic = Lstatistic.find(params[:id])
  end

  # POST /lstatistics
  # POST /lstatistics.xml
  def create
    @lstatistic = Lstatistic.new(params[:lstatistic])

    respond_to do |format|
      if @lstatistic.save
        format.html { redirect_to(@lstatistic, :notice => 'Lstatistic was successfully created.') }
        format.xml  { render :xml => @lstatistic, :status => :created, :location => @lstatistic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lstatistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lstatistics/1
  # PUT /lstatistics/1.xml
  def update
    @lstatistic = Lstatistic.find(params[:id])

    respond_to do |format|
      if @lstatistic.update_attributes(params[:lstatistic])
        format.html { redirect_to(@lstatistic, :notice => 'Lstatistic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lstatistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lstatistics/1
  # DELETE /lstatistics/1.xml
  def destroy
    @lstatistic = Lstatistic.find(params[:id])
    @lstatistic.destroy

    respond_to do |format|
      format.html { redirect_to(lstatistics_url) }
      format.xml  { head :ok }
    end
  end
end
