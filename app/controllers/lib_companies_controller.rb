class LibCompaniesController < ApplicationController
  # GET /lib_companies
  # GET /lib_companies.xml
  layout "admin"
  def index
   # @lib_companies = LibCompanyTest.desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>50)
   @not_sent= @lib_companies = LibCompany.where(:sent_counter=>nil).count
    @sent_one= @lib_companies = LibCompany.where(:sent_counter=>1).count
    @sent_two= @lib_companies = LibCompany.where(:sent_counter=>2).count
     @sent_three_and_above= @lib_companies = LibCompany.where(:sent_counter.gte=>2).count
    @lib_companies = LibCompany.desc(:updated_at).paginate(:page=>params[:page]||1,:per_page=>500)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lib_companies }
    end
  end

  # GET /lib_companies/1
  # GET /lib_companies/1.xml
  def show
    @lib_company = LibCompany.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lib_company }
    end
  end

  # GET /lib_companies/new
  # GET /lib_companies/new.xml
  def new
    @lib_company = LibCompany.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lib_company }
    end
  end

  # GET /lib_companies/1/edit
  def edit
    @lib_company = LibCompany.find(params[:id])
  end

  # POST /lib_companies
  # POST /lib_companies.xml
  def create
    @lib_company = LibCompany.new(params[:lib_company])

    respond_to do |format|
      if @lib_company.save
        format.html { redirect_to(@lib_company, :notice => 'Lib company was successfully created.') }
        format.xml  { render :xml => @lib_company, :status => :created, :location => @lib_company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lib_company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lib_companies/1
  # PUT /lib_companies/1.xml
  def update
    @lib_company = LibCompany.find(params[:id])

    respond_to do |format|
      if @lib_company.update_attributes(params[:lib_company])
        format.html { redirect_to(@lib_company, :notice => 'Lib company was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lib_company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lib_companies/1
  # DELETE /lib_companies/1.xml
  def destroy
    @lib_company = LibCompany.find(params[:id])
    @lib_company.destroy

    respond_to do |format|
      format.html { redirect_to(lib_companies_url) }
      format.xml  { head :ok }
    end
  end
end
