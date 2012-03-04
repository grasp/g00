#coding:utf-8
class PlansController < ApplicationController
  # GET /plans
  # GET /plans.json
  include PlansHelper
  include_kindeditor :only => [:new, :edit]
  before_filter:admin_authorize
  layout "plan"
  def index
    init_plan
    search_critial= Hash.new
    search_critial[:user]=params[:user] if  params[:user]
    search_critial[:system]=params[:system] if  params[:system]
    search_critial[:plansetting]=params[:plansetting] if  params[:plansetting]
    search_critial[:branch]=params[:branch] if  params[:branch]
    search_critial[:fa]=params[:fa] if  params[:fa]
    search_critial[:created_at.gte]=Time.now.ago(86400*params[:week].to_i) if  params[:week] 
     @url=request.url
    if params[:sort]==nil
    params[:sort]="priority" 
    else
      @url=@url.gsub("/sort/#{params[:sort]}","").to_s
    end


    if search_critial.size>0      
      # puts "search critial=#{search_critial}"
      #  @plans = Plan.where(search_critial).desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>50)
      @plans = Plan.where(search_critial).desc(params[:sort]).paginate(:page=>params[:page]||1,:per_page=>50)
    else
      #  puts "no      search critial"
      #  @plans = Plan.all.desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>50)
      @plans = Plan.all.desc(params[:sort]).paginate(:page=>params[:page]||1,:per_page=>50)
    end

    respond_to do |format|
      if params[:layout]
        format.html {render :layout=>nil}# index.html.erb
      else
        format.html # index.html.erb
      end
   
      format.json { render json: @plans }
    end
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
    @plan = Plan.find(params[:id])

    respond_to do |format|
      if params[:layout]
        format.html{ render :layout=>nil} # show.html.erb
      else
        format.html # show.html.erb
   
      end
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
    puts "@plan_setting.id=#{@plan_setting.id}"
    @plan.update_attributes(:system=>@plan_setting.system,:branch=>@plan_setting.branch,:fa=>@plan_setting.fa,:plansetting=>@plan_setting.id)
    
    respond_to do |format|
      format.html { redirect_to :action=>"edit",:id=>@plan.id,notice: 'Plan was successfully created.' }
      format.json { render json: @plan }
    end
  end
  # GET /plans/1/edit
  def edit
    init_plan    
    @plan = Plan.find(params[:id]) 

    puts "flash notice=#{flash[:notice]}"
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
    @plan_setting=PlanSetting.find(@plan.plansetting)
    init_plan   
    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        unless @plan_setting.contributor.include?(@plan.user)
          @plan_setting.add_to_set(:contributor,@plan.user)
        end
        #  format.html { redirect_to @plan, notice: 'Plan was successfully updated.' }
        flash[:notice]="Plan更新成功在-#{Time.now.to_s.slice(0,19)}"
        if params[:content].size>0
          format.html { redirect_to action: "edit" ,:content=>params[:content],:flash=>{:notice=>flash[:notice]}}
        else
          format.html { redirect_to action: "edit" ,:flash=>{:notice=>flash[:notice]}}
        end
        format.json { head :no_content }
      else
        flash[:notice]="Plan更新失败"
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
