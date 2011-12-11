class AnnouncesController < ApplicationController
  # GET /announces
  # GET /announces.xml
   layout :choose_layout 
  
  def choose_layout  
    return  nil if  action_name=="show"
    return 'admin'
  end
  
  def index
    @announces = Announce.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @announces }
    end
  end

  # GET /announces/1
  # GET /announces/1.xml
  def show
    @announce = Announce.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @announce }
    end
  end

  # GET /announces/new
  # GET /announces/new.xml
  def new
    @announce = Announce.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @announce }
    end
  end

  # GET /announces/1/edit
  def edit
    @announce = Announce.find(params[:id])
  end

  # POST /announces
  # POST /announces.xml
  def create
    @announce = Announce.new(params[:announce])

    respond_to do |format|
      if @announce.save
        format.html { redirect_to(@announce, :notice => 'Announce was successfully created.') }
        format.xml  { render :xml => @announce, :status => :created, :location => @announce }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @announce.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /announces/1
  # PUT /announces/1.xml
  def update
    @announce = Announce.find(params[:id])

    respond_to do |format|
      if @announce.update_attributes(params[:announce])
        format.html { redirect_to(@announce, :notice => 'Announce was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @announce.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /announces/1
  # DELETE /announces/1.xml
  def destroy
    @announce = Announce.find(params[:id])
    @announce.destroy

    respond_to do |format|
      format.html { redirect_to(announces_url) }
      format.xml  { head :ok }
    end
  end
end
