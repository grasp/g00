class PlansController < ApplicationController
  # GET /plans
  # GET /plans.json
  include PlansHelper
  include_kindeditor :only => [:new, :edit]
  before_filter:admin_authorize
  layout "admin"
  def index
    init_plan
    search_critial= Hash.new
    search_critial[:user]=params[:user] if  params[:user]
    search_critial[:system]=params[:system] if  params[:system]
    search_critial[:created_at.gte]=Time.now.ago(86400*params[:week].to_i) if  params[:week]   
    if search_critial.size>0      
      puts "search critial=#{search_critial}"
      @plans = Plan.where(search_critial).paginate(:page=>params[:page]||1,:per_page=>25)
    else
      puts "no      search critial"
      @plans = Plan.all.paginate(:page=>params[:page]||1,:per_page=>25)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plans }
    end
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
    @plan = Plan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plan }
    end
  end

  # GET /plans/new
  # GET /plans/new.json
  def new
    if params[:id]
      @plan_setting=PlanSetting.find(params[:id])
    end

    @plan = Plan.new
    @plan.update_attributes(:system=>@plan_setting.system,:branch=>@plan_setting.branch,:fa=>@plan_setting.fa)
    respond_to do |format|
      format.html { redirect_to :action=>"edit",:id=>@plan.id,notice: 'Plan was successfully created.' }
      format.json { render json: @plan }
    end
  end
  # GET /plans/1/edit
  def edit
    init_plan    
    @plan = Plan.find(params[:id])
  end
  
  def plan_edit
    init_plan
    @plan = Plan.find(params[:id])
  end
  def do_edit
    init_plan
    @plan = Plan.find(params[:id])
  end
  def summary_edit
    init_plan
    @plan = Plan.find(params[:id])
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(params[:plan])

    respond_to do |format|
      if @plan.save
        format.html { redirect_to @plan, notice: 'Plan was successfully created.' }
        format.json { render json: @plan, status: :created, location: @plan }
      else
        format.html { render action: "new" }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /plans/1
  # PUT /plans/1.json
  def update
    @plan = Plan.find(params[:id])

    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        format.html { redirect_to @plan, notice: 'Plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to plans_url }
      format.json { head :no_content }
    end
  end
end
