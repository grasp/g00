 # coding: utf-8
class CargoCategoriesController < ApplicationController
  # GET /cargo_categories
  # GET /cargo_categories.xml
  layout :nil
  def index
    @cargo_categories = CargoCategory.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cargo_categories }
    end
  end

  # GET /cargo_categories/1
  # GET /cargo_categories/1.xml
  def show
    code=params[:code]
     if (code.match(/\d\d0000/))
           @cargo_category_two=$catetree[code]
     elsif(code.match(/\d\d\d\d00/))
           parent_code=code[0,2]+"0000"
           @cargo_category_two=$catetree[code][parent_code]          
     else
           parent_code=code[0,4]+"00"
           ancient_code=code[0,2]+"0000"
           @cargo_category_two=$catetree[ancient_code]
           @cargo_category_three = $catetree[ancient_code][parent_code]
     end
 
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cargo_category }
    end
  end

  # GET /cargo_categories/new
  # GET /cargo_categories/new.xml
  def new
    @cargo_category = CargoCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cargo_category }
    end
  end

  # GET /cargo_categories/1/edit
  def edit
    @cargo_category = CargoCategory.find(params[:id])
  end

  # POST /cargo_categories
  # POST /cargo_categories.xml
  def create
    @cargo_category = CargoCategory.new(params[:cargo_category])

    respond_to do |format|
      if @cargo_category.save
        format.html { redirect_to(@cargo_category, :notice => 'Cargo category was successfully created.') }
        format.xml  { render :xml => @cargo_category, :status => :created, :location => @cargo_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cargo_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cargo_categories/1
  # PUT /cargo_categories/1.xml
  def update
    @cargo_category = CargoCategory.find(params[:id])

    respond_to do |format|
      if @cargo_category.update_attributes(params[:cargo_category])
        format.html { redirect_to(@cargo_category, :notice => 'Cargo category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cargo_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cargo_categories/1
  # DELETE /cargo_categories/1.xml
  def destroy
    @cargo_category = CargoCategory.find(params[:id])
    @cargo_category.destroy

    respond_to do |format|
      format.html { redirect_to(cargo_categories_url) }
      format.xml  { head :ok }
    end
  end
end
