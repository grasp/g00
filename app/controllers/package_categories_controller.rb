 # coding: utf-8
class PackageCategoriesController < ApplicationController
  # GET /package_categories
  # GET /package_categories.xml
  layout:nil
  
  def index
    @package_categories = PackageCategory.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @package_categories }
    end
  end

  # GET /package_categories/1
  # GET /package_categories/1.xml
  def show
    
  # @package_category = PackageCategory.find_by_code(params[:code])
   
    code=params[:code]
  #  puts code
     if (code.match(/\d000/))
           @package_category_two=$packagetree[code]
     else
           parent_code=code[0]+"000"
           @package_category_two=$packagetree[parent_code]
     end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package_category }
    end
  end

  # GET /package_categories/new
  # GET /package_categories/new.xml
  def new
    @package_category = PackageCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @package_category }
    end
  end

  # GET /package_categories/1/edit
  def edit
    @package_category = PackageCategory.find(params[:id])
  end

  # POST /package_categories
  # POST /package_categories.xml
  def create
    @package_category = PackageCategory.new(params[:package_category])

    respond_to do |format|
      if @package_category.save
        format.html { redirect_to(@package_category, :notice => 'Package category was successfully created.') }
        format.xml  { render :xml => @package_category, :status => :created, :location => @package_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @package_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /package_categories/1
  # PUT /package_categories/1.xml
  def update
    @package_category = PackageCategory.find(params[:id])

    respond_to do |format|
      if @package_category.update_attributes(params[:package_category])
        format.html { redirect_to(@package_category, :notice => 'Package category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @package_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /package_categories/1
  # DELETE /package_categories/1.xml
  def destroy
    @package_category = PackageCategory.find(params[:id])
    @package_category.destroy

    respond_to do |format|
      format.html { redirect_to(package_categories_url) }
      format.xml  { head :ok }
    end
  end
end
