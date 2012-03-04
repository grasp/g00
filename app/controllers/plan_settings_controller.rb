class PlanSettingsController < ApplicationController
  # GET /plan_settings
  # GET /plan_settings.json
  layout "plan"
  before_filter:admin_authorize
  include PlanSettingsHelper
  def index
    init_plan_setting if PlanSetting.count<3 #first init    
   
     search_critial= Hash.new
    search_critial[:user]=params[:user] if  params[:user]
    if  params[:system]
      @system=[params[:system]]
     search_critial[:system]=params[:system]
    else
       @system=get_all_system 
    end
    
puts  search_critial
    if search_critial.size>0
        @plan_settings = PlanSetting.where(search_critial).desc(:updated_at)
    else
        @plan_settings = PlanSetting.all.desc(:updated_at)
    end
   
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plan_settings }
    end
  end

  # GET /plan_settings/1
  # GET /plan_settings/1.json
  def show
    @plan_setting = PlanSetting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plan_setting }
    end
  end

  # GET /plan_settings/new
  # GET /plan_settings/new.json
  def new
    @plan_setting = PlanSetting.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plan_setting }
    end
  end

  # GET /plan_settings/1/edit
  def edit
    @plan_setting = PlanSetting.find(params[:id])
  end

  # POST /plan_settings
  # POST /plan_settings.json
  def create
  #  params[:plan_setting][:contributor]=[params[:plan_setting][:creater]]
    @plan_setting = PlanSetting.new(params[:plan_setting])

    respond_to do |format|
      if @plan_setting.save
        @plan_setting.add_to_set(:contributor,params[:plan_setting][:creater])
        format.html { redirect_to @plan_setting, notice: 'Plan setting was successfully created.' }
        format.json { render json: @plan_setting, status: :created, location: @plan_setting }
      else
        format.html { render action: "new" }
        format.json { render json: @plan_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /plan_settings/1
  # PUT /plan_settings/1.json
  def update
    @plan_setting = PlanSetting.find(params[:id])

    respond_to do |format|
      if @plan_setting.update_attributes(params[:plan_setting])
        format.html { redirect_to @plan_setting, notice: 'Plan setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plan_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plan_settings/1
  # DELETE /plan_settings/1.json
  def destroy
    @plan_setting = PlanSetting.find(params[:id])
    @plan_setting.destroy

    respond_to do |format|
      format.html { redirect_to plan_settings_url }
      format.json { head :no_content }
    end
  end
end
