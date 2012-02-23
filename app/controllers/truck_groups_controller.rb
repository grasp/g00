#coding:utf-8
class TruckGroupsController < ApplicationController
  # GET /truck_groups
  # GET /truck_groups.json
  
  layout "dingwei"
  
  def index
    @truck_groups = TruckGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @truck_groups }
    end
  end

  # GET /truck_groups/1
  # GET /truck_groups/1.json
  def show
    @truck_group = TruckGroup.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @truck_group }
    end
  end

  # GET /truck_groups/new
  # GET /truck_groups/new.json
  def new
    @truck_group = TruckGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @truck_group }
    end
  end

  # GET /truck_groups/1/edit
  def edit
    @truck_group = TruckGroup.find(params[:id])
  end

  # POST /truck_groups
  # POST /truck_groups.json
  def create
    @truck_group = TruckGroup.new(params[:truck_group])

    respond_to do |format|
      if @truck_group.save
        format.html { redirect_to @truck_group, notice: '车队创建成功' }
        format.json { render json: @truck_group, status: :created, location: @truck_group }
      else
        format.html { render action: "new" }
        format.json { render json: @truck_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /truck_groups/1
  # PUT /truck_groups/1.json
  def update
    @truck_group = TruckGroup.find(params[:id])

    respond_to do |format|
      if @truck_group.update_attributes(params[:truck_group])
        format.html { redirect_to @truck_group, notice: 'Truck group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @truck_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /truck_groups/1
  # DELETE /truck_groups/1.json
  def destroy
    @truck_group = TruckGroup.find(params[:id])
    @truck_group.destroy

    respond_to do |format|
      format.html { redirect_to truck_groups_url }
      format.json { head :no_content }
    end
  end
end
