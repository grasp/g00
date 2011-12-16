 # coding: utf-8
 


module CargosHelper
    include FileUtils
    include CitiesHelper

 #for view storage purpose, but now use page cache 
 def get_search_cargos(fcity_code,tcity_code)   
   if fcity_code=="100000000000" && tcity_code=="100000000000" then
   @cargos=Cargo.where(:status=>"正在配车").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
    elsif fcity_code=="100000000000" && tcity_code!="100000000000"
      result=get_max_min_code(tcity_code)
      min=result[0];      max=result[1]
      if result[2]
        @cargos=Cargo.where({:tcity_code=>min,:status=>"正在配车"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
      else
        @cargos=Cargo.where({:tcity_code.gte=>min,:tcity_code.lt=>max,:status=>"正在配车"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
       end
     elsif tcity_code=="100000000000" && fcity_code!="100000000000"
      result=get_max_min_code(fcity_code)
      min=result[0];    max=result[1]
      if result[2]
        @cargos=Cargo.where({:fcity_code=>min,:status=>"正在配车"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
      else
        @cargos=Cargo.where({:fcity_code.gte =>min,:fcity_code.lt =>max,:status=>"正在配车"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
      end
    else
   
     resultt=get_max_min_code(tcity_code)
      mint=resultt[0];  maxt=resultt[1]
    
     resultf=get_max_min_code(fcity_code)
      minf=resultf[0];  maxf=resultf[1]

    #  puts "mint=#{mint}, maxt=#{maxt},minf=#{minf},maxf=#{maxf},resultt[2]=#{resultt[2]},resultf=#{resultf[2]}"
      if resultt[2]==false && resultf[2]==false  
        @cargos=Cargo.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"正在配车"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
      elsif resultt[2]==true && resultf[2]==false  
        @cargos=Cargo.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code=>mint,:status=>"正在配车"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
      elsif resultt[2]==false && resultf[2]==true
        @cargos=Cargo.where({:fcity_code=>minf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"正在配车"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
      else
        @cargos=Cargo.where(:fcity_code =>minf,:tcity_code=>mint,:status=>"正在配车").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
        end
    end
    @cargos
 end
 
 def search_helper
    @search=Search.new
    if params[:search].nil?      
      unless params[:from].blank?
         @search.fcity_code=params[:from]
         @search.fcity_name=$city_code_name[params[:from]]
     else
        @search.fcity_code="100000000000"
        @search.fcity_name="出发地选择"
     end
     unless params[:to].blank?
        @search.tcity_code=params[:to]
        @search.tcity_name=$city_code_name[params[:to]] 
     else
         @search.tcity_name="到达地选择"
         @search.tcity_code="100000000000"
     end
    else
      @search.fcity_name=params[:search][:fcity_name]
      @search.tcity_name=params[:search][:tcity_name]
      @search.fcity_code=params[:search][:fcity_code]
      @search.tcity_code=params[:search][:tcity_code]
    end

    #puts "@search.fcity_code=#{@search.fcity_code},@search.tcity_code=#{@search.tcity_code}";
    @line=@search.fcity_code+"#"+@search.tcity_code
   # @action_suffix="#{@line}#{params[:page]}"        
    @search.save
    #add search times
    @cargos=get_search_cargos(@search.fcity_code,@search.tcity_code)
    respond_to do |format|
    if params[:layout]     
      format.html  
    else
     format.html {render :layout=>"cargo"}
    end
    end
 end

 def expire_line_cargo(from_city,to_city)   
   lines=Array.new
  if (from_city!="100000000000" && to_city!="100000000000")
    lines<<[from_city,to_city] #expire city to city 
    lines<<[from_city.slice(0,4)+"00000000",to_city] #expire region to city
    lines<<[from_city.slice(0,2)+"0000000000",to_city] #province to city
    lines<<["100000000000",to_city] #expire anywhere  to city  
    lines<<["100000000000",to_city.slice(0,4)+"00000000"] #expire anywhere  to region  
    lines<<["100000000000",to_city.slice(0,2)+"0000000000"] #expire anywhere to province  
     
    lines<<[from_city,to_city.slice(0,4)+"00000000"] #city to region
    lines<<[from_city,to_city.slice(0,2)+"0000000000"] #city  to province
    lines<<[from_city,"100000000000"]  #expire city to anywhere
    lines<<[from_city.slice(0,4)+"00000000","100000000000"]  #expire region to anywhere
    lines<<[from_city.slice(0,2)+"0000000000","100000000000"]  #expire province to anywhere
    
   lines<<[from_city.slice(0,4)+"00000000",to_city.slice(0,4)+"00000000"] #expire region to region 
   lines<<[from_city.slice(0,2)+"0000000000",to_city.slice(0,2)+"0000000000"] #expire province to province 
   lines<<[from_city.slice(0,4)+"00000000",to_city.slice(0,2)+"0000000000"] #expire region to province 
   lines<<[from_city.slice(0,2)+"0000000000",to_city.slice(0,4)+"00000000"] #expire province  to region 
  
  
   all_lines=lines.uniq
  
   #rm folder
   all_lines.each do |line|
     FileUtils.rm_rf Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"       
     Rails.logger.debug "expire "+Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"
   end
  else
    #only expire first page, others only Cargos.count/ % 20 ==0 to expire
    # if Cargo.count % 20 ==0
    #    FileUtils.rm_rf Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}"   
    # else
   #     FileUtils.rm_rf Rails.public_path+"/cargos/search"+"/#{line[0]}"+"/#{line[1]}/1.html"       
   #  end
    end

 
 end
def get_city_cargo_count(cityid)
   from_count=0;to_count=0;
   from_count=Cargo.where(:fcity_code=>cityid.to_s).count
   to_count=Cargo.where(:tcity_code=>cityid.to_s).count
   repeatcount=Cargo.where(:fcity_code=>cityid.to_s,:tcity_code=>cityid.to_s).count
   from_count+to_count- repeatcount
end

 def get_province_cargo_from_count(province)
 next_province=province+10000000000
return Cargo.where(:status=>"正在配车",:fcity_code.gte=>province.to_s,:fcity_code.lt=> next_province.to_s).count
 end

  def get_province_cargo_to_count(province)
 next_province=province+10000000000
return Cargo.where(:status=>"正在配车",:tcity_code.gte=>province.to_s,:tcity_code.lt=> next_province.to_s).count
 end


 def get_region_cargo_from_count(regioncity)
    next_region=regioncity.to_i+100000000
    return Cargo.where(:status=>"正在配车",:fcity_code.gte=>regioncity.to_s,:fcity_code.lt=> next_region.to_s).count
 end
 def get_region_cargo_to_count(regioncity)
    next_region=regioncity.to_i+100000000
    return Cargo.where(:status=>"正在配车",:tcity_code.gte=>regioncity.to_s,:tcity_code.lt=> next_region.to_s).count
 end
 
 def cargo_show_helper
   unless @error

    @cargo = Cargo.find(params[:id])  

    @contact=  @cargo.comments  if @cargo[:from_site]=="haoyun56"
    @contact=  @cargo.comments  if @cargo[:from_site]=="56135"
    @contact=  @cargo.comments+"联系电话:"+@cargo.contact  if @cargo[:from_site]=="56qq"
    @contact=  @cargo.comments  if @cargo[:from_site]=="tf56"
    @contact=  @cargo.contact_phone if @cargo[:from_site]=="quzhou"
    @jubao_counter=Jubao.where(:belongid=>@cargo.id).count
    if @cargo[:from_site]=="local"
       @stock_cargo=StockCargo.find(@cargo.stock_cargo_id)
       @user=User.find(@cargo.user_id)
    end

    if @line_ad.blank?

    end
   end
 end

 def     cargo_allcity_helper
     @search=Search.new;    @search.fcity_code="100000000000";    @search.tcity_code="100000000000"
     @cargos=Cargo.where(:status=>"正在配车") .desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
 end
 
 def cargo_city_helper
     @search=Search.new;    @search.fcity_code=params[:city_id];    @search.tcity_code="100000000000"

    cityid=params[:city_id]
    if @province and @region.blank? and @city.blank? # is a province id
      @is_province=true
      next_province=cityid.to_i+10000000000
      @cargos = Cargo.any_of([{:status=>"正在配车",:fcity_code.gte=>cityid.to_s,:fcity_code.lt=> next_province.to_s},
          {:status=>"正在配车",:tcity_code.gte=>cityid.to_s,:tcity_code.lt=> next_province.to_s}]).desc(:created_at)
      .paginate(:page=>params[:page]||1,:per_page=>25)
      
    elsif  @province and @region and @city.blank?  and params[:citytype]!="city" # is a region
      @region=params[:city_id]
       next_region=cityid.to_i+100000000
       @cargos=Cargo.any_of([{:status=>"正在配车",:fcity_code.gte=>cityid.to_s,:fcity_code.lt=> next_region.to_s},
          {:status=>"正在配车",:tcity_code.gte=>cityid.to_s,:tcity_code.lt=> next_region.to_s}]).desc(:created_at)
      .paginate(:page=>params[:page]||1,:per_page=>25)
    else
     @region=params[:city_id].slice(0,4)+"00000000"
    @cargos=Cargo.any_of([{:status=>"正在配车",:fcity_code=>cityid.to_s},
          {:status=>"正在配车",:tcity_code=>cityid.to_s}]).desc(:created_at)
      .paginate(:page=>params[:page]||1,:per_page=>25)
    end
    #we want to sort the region as the number
    @region_list=Array.new
    $province_tree[@province.to_s].each do |regioncity|     
     @region_list<<[regioncity,$city_code_name[regioncity],get_region_cargo_from_count(regioncity),get_region_cargo_to_count(regioncity)]
    end
    @region_list.sort_by!{|x| x[2]}.reverse! #now sory by from number
     
    if @region 
      @city_list=Array.new #we want to sort the city by the number of huo or che
      $citytree[@province][@region].each do |code,name|
        count=Cargo.any_of([{:status=>"正在配车",:fcity_code=>code.to_s},
          {:status=>"正在配车",:tcity_code=>code.to_s}]).count
        @city_list<<[code,name,count]
      end
      #add region statistic here, this is city code same as region code
          count=Cargo.any_of([{:status=>"正在配车",:fcity_code=>@region.to_s},
          {:status=>"正在配车",:tcity_code=>@region.to_s}]).count
          @city_list<<[@region,$city_code_name[@region],count]
          @city_list.sort_by!{|x| x[2]}.reverse!
    end
 end
end
