class JubaosController < ApplicationController
  # GET /jubaos
  # GET /jubaos.xml
  layout :choose_layout
   before_filter:admin_authorize,:only=>[:index] #for debug purpose
   def choose_layout
     return "admin" if action_name=="index"
     return nil
   end
  def index
    @jubaos = Jubao.desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jubaos }
    end
  end

  # GET /jubaos/1
  # GET /jubaos/1.xml
  def show
    @jubao = Jubao.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @jubao }
    end
  end

  # GET /jubaos/new
  # GET /jubaos/new.xml
  def new
    @jubao = Jubao.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @jubao }
    end
  end

  # GET /jubaos/1/edit
  def edit
    @jubao = Jubao.find(params[:id])
  end

  # POST /jubaos
  # POST /jubaos.xml
  def create
    @jubao = Jubao.new(params[:jubao])
    if params[:jubao][:username]
       count=Jubao.where(:belongid=>params[:jubao][:belongid],:username=>params[:jubao][:username]).count
    else
       count=Jubao.where(:belongid=>params[:jubao][:belongid],:fromip=>params[:jubao][:fromip] ).count
    end
  
   if count==0
     expire_fragment params[:jubao][:jubaotype]+"show"+params[:jubao][:belongid] #cargo and truck type
    end
     
    respond_to do |format|
      if count==0
        @jubao.save
        format.html { redirect_to(@jubao, :notice => 'Jubao was successfully created.') }
        format.xml  { render :xml => @jubao, :status => :created, :location => @jubao }
      else
         format.html { render :action => "new" }
        format.xml  { render :xml => @jubao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jubaos/1
  # PUT /jubaos/1.xml
  def update
    @jubao = Jubao.find(params[:id])

    respond_to do |format|
      if @jubao.update_attributes(params[:jubao])
        format.html { redirect_to(@jubao, :notice => 'Jubao was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @jubao.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jubaos/1
  # DELETE /jubaos/1.xml
  def destroy
    @jubao = Jubao.find(params[:id])
    @jubao.destroy

    respond_to do |format|
      format.html { redirect_to(jubaos_url) }
      format.xml  { head :ok }
    end
  end
end
