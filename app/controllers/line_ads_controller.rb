class LineAdsController < ApplicationController
  # GET /line_ads
  # GET /line_ads.xml
    layout nil
  def index
    @line_ads = LineAd.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @line_ads }
    end
  end

  # GET /line_ads/1
  # GET /line_ads/1.xml
  def show
    @line_ad = LineAd.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @line_ad }
    end
  end

  # GET /line_ads/new
  # GET /line_ads/new.xml
  def new
    @line_ad = LineAd.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @line_ad }
    end
  end

  # GET /line_ads/1/edit
  def edit
    @line_ad = LineAd.find(params[:id])
  end

  # POST /line_ads
  # POST /line_ads.xml
  def create
    @line_ad = LineAd.new(params[:line_ad])

    respond_to do |format|
      if @line_ad.save
        format.html { redirect_to(@line_ad, :notice => 'Line ad was successfully created.') }
        format.xml  { render :xml => @line_ad, :status => :created, :location => @line_ad }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @line_ad.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /line_ads/1
  # PUT /line_ads/1.xml
  def update
    @line_ad = LineAd.find(params[:id])

    respond_to do |format|
      if @line_ad.update_attributes(params[:line_ad])
        format.html { redirect_to(@line_ad, :notice => 'Line ad was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @line_ad.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /line_ads/1
  # DELETE /line_ads/1.xml
  def destroy
    @line_ad = LineAd.find(params[:id])
    @line_ad.destroy

    respond_to do |format|
      format.html { redirect_to(line_ads_url) }
      format.xml  { head :ok }
    end
  end
end
