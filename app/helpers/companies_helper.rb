# coding: utf-8
module CompaniesHelper
   include CitiesHelper
  def get_company_from_params(params)  
    params[:company][:fix_phone]=params[:quhao]+"-"+ params[:company][:fix_phone]
    @user_id=session[:user_id]
    @user_name=session[:user_id]
    params[:company][:user_id]=@user_id

    @company = Company.create!( params[:company])
    @company.user.company_id= @company.id

    if   @company
    #  puts "success created"
      return true
    else
      return false
    end
  end
  def update_company(params)

    @user_id=session[:user_id]

    if @company[:user_id]!=@user_id
      flash[:notice]="你不是该信息创建者不能编辑"
      return nil
    end

    if @company
      params[:company][:fix_phone]=params[:quhao]+"-"+ params[:company][:fix_phone]
      @company.update_attributes!(params[:company])
      return  @company
    else
      flash[:notice]="该公司不存在"
      return nil
    end

  end
  
   def split_array(array,n)
   new_array=Array.new
   array_size=array.size
    small_array= Array.new  
    0.upto(array_size-1).each do |i|  
    small_array<< array[i] unless  array[i].nil?
      if (i+1)%n==0 
      new_array<<small_array
      small_array= Array.new        
      end     
    
    end   
   new_array
 end
 
  def yellowpage_helper
    # expire_fragment('yellowpage')
    @companies_array=Array.new
    @latest_array=Array.new
    @companies = Company.desc(:created_at).limit(100)
       @companies=@companies.reverse
    @latest_companies=Company.desc(:created_at).limit(9)
    @companies_array= split_array(@companies,3)
    @latest_array=split_array(@latest_companies,3)
   # puts "@latest_array=#{@latest_array.size},@latest_companies=#{@latest_companies.size}"
   # @latest_array.each do |cblock|
  #    puts "cblock size=#{cblock.size}"
  #  end
  end
  
  
  def get_search_companies(citycode)   
   if citycode=="100000000000" then
   @companies=Company.desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>20)

   else citycode!="100000000000"
      result=get_max_min_code(citycode)
      min=result[0];    max=result[1]
    #  puts "min=#{min},max=#{max},result=#{result[2]}"
    if result[2]
    @companies=Company.where(:city_code=>min).desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>20)
      else
    @companies=Company.where(:city_code.gte =>min,:city_code.lt =>max).desc(:created_at).asc(:priority).paginate(:page=>params[:page]||1,:per_page=>20)
      end


    end
@companies
 end
end
