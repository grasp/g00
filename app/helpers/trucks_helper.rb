 # coding: utf-8
module TrucksHelper
  include FileUtils
  def get_truck_info_from_params(params)

  params[:truck][:user_id]=session[:user_id]
  begin
  @truck = Truck.create!(params[:truck])
  rescue
    raise
    return nil
  end
   return @truck
end

  def update_truck_info_from_params(params)

    if  @truck
       @truck.update_attributes( params[:truck])
      return @truck
    else
      return nil
    end

  end
  
  # This is for view cache purpose
def get_search_truck(fcity_code,tcity_code)    
 if fcity_code=="100000000000" && tcity_code=="100000000000" then   
     @trucks=Truck.where(:status=>"正在配货").desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
   elsif fcity_code=="100000000000" && tcity_code!="100000000000"
      result=get_max_min_code(tcity_code)
      min=result[0]
      max=result[1]
      if result[2]
        @trucks=Truck.where({:tcity_code=>min,:status=>"正在配货"}).desc(:created_at).
         paginate(:page=>params[:page]||1,:per_page=>20)
      else
         @trucks=Truck.where({:tcity_code.gte=>min,:tcity_code.lt=>max,:status=>"正在配货"}).desc(:created_at).
                      paginate(:page=>params[:page]||1,:per_page=>20)
      end
    elsif tcity_code=="100000000000" && fcity_code!="100000000000"
     result=get_max_min_code(fcity_code)
     min=result[0]
     max=result[1]
     if result[2]
       @trucks=Truck.where({:fcity_code =>min,:status=>"正在配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
     else
       @trucks=Truck.where({:fcity_code.gte =>min,:fcity_code.lt =>max,:status=>"正在配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20)
     end
 
    else
     resultt=get_max_min_code(tcity_code)
     resultf=get_max_min_code(fcity_code)
      mint=resultt[0]
      maxt=resultt[1]
      minf=resultf[0]
      maxf=resultf[1]
    #  puts "mint=#{mint}, maxt=#{maxt},minf=#{minf},maxf=#{maxf}"
      if resultt[2]==false && resultf[2]==false
      #  puts "两个都不是县级市"
          @trucks=Truck.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"正在配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20 )
       elsif resultt[2]==true && resultf[2]==false
       #   puts "到达是县级市"
          @trucks=Truck.where({:fcity_code.gte =>minf,:fcity_code.lt =>maxf,:tcity_code=>mint,:status=>"正在配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20 )
       elsif resultt[2]==false && resultf[2]==true
        #   puts "出发是县级市"
          @trucks=Truck.where({:fcity_code =>minf,:tcity_code.gte=>mint,:tcity_code.lt=>maxt,:status=>"正在配货"}).desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>20 )
       else
       #  puts "两个都是县级市"
          @trucks=Truck.where({:fcity_code =>minf,:tcity_code=>mint,:status=>"正在配货"}).desc(:created_at).all.paginate(:page=>params[:page]||1,:per_page=>20 )
      end
    end    
  end
  
  def cal_expire_city(from_city,to_city)   
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
   
    all_lines
  end
 end
 def iterate_expire_line(line,from_city,to_city)
      line =line+cal_expire_city(from_city,to_city)
      line=line.uniq
      line
 end
    
 def expire_line_truck(from_city,to_city)   
   all_lines=cal_expire_city(from_city,to_city)   
  
   #rm folder
   all_lines.each do |line|
     FileUtils.rm_rf Rails.public_path+"/trucks/search"+"/#{line[0]}"+"/#{line[1]}"       
     Rails.logger.debug "expire "+Rails.public_path+"/trucks/search"+"/#{line[0]}"+"/#{line[1]}"
   end

  end


 def get_city_truck_count(cityid)
   from_count=0;to_count=0;
   from_count=Truck.where(:fcity_code=>cityid.to_s).count
   to_count=Truck.where(:tcity_code=>cityid.to_s).count
   repeatcount=Truck.where(:fcity_code=>cityid.to_s,:tcity_code=>cityid.to_s).count
   from_count+to_count- repeatcount
end

 def get_province_truck_from_count(province)
 next_province=province+10000000000
return Truck.where(:status=>"正在配货",:fcity_code.gte=>province.to_s,:fcity_code.lt=> next_province.to_s).count
 end

  def get_province_truck_to_count(province)
 next_province=province+10000000000
return Truck.where(:status=>"正在配货",:tcity_code.gte=>province.to_s,:tcity_code.lt=> next_province.to_s).count
 end


 def get_region_truck_from_count(regioncity)
    next_region=regioncity.to_i+100000000
    return Truck.where(:status=>"正在配货",:fcity_code.gte=>regioncity.to_s,:fcity_code.lt=> next_region.to_s).count
 end
 def get_region_truck_to_count(regioncity)
    next_region=regioncity.to_i+100000000
    return Truck.where(:status=>"正在配货",:tcity_code.gte=>regioncity.to_s,:tcity_code.lt=> next_region.to_s).count
 end
 
 def truck_show_helper
   @error=false
   begin
    @truck = Truck.find(params[:id])
   rescue
     @error=true
   end
    if not @error
     @contact=  "司机 #{@truck.driver_name || '无'}"+"电话 #{@truck.driver_phone || '无'}"+"随车电话 #{@truck.car_phone || '无'}"  if  @truck[:from_site]=="tf56"
     @contact= @truck.comments+@truck.contact if  @truck[:from_site]=="56qq"
     @contact= @truck.contact_phone if  @truck[:from_site]=="quzhou"
    @jubao_counter=Jubao.where(:belongid=>@truck.id).count
    if @truck[:from_site]=="local"
       @stock_truck=StockTruck.find( @truck.stock_truck_id)
       @user=User.find(@truck.user_id)
       @user_contact=UserContact.find( @user.user_contact_id) if @user.user_contact_id
    end
    
    #  @line_ad=LineAd.find({:line=>get_line(@cargo.fcity_code,@cargo.tcity_code)})
    if @line_ad.blank?
      #@line_ad=LineAd.find_by_line("0")
      #@line_ad.fcity_name=@cargo.fcity_name
      #@line_ad.tcity_name=@cargo.tcity_name
    end
    end
 end
def truck_allcity_helper
       @search=Search.new;    @search.fcity_code="100000000000";    @search.tcity_code="100000000000"
      @trucks=Truck.where(:status=>"正在配货") .desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
end

def truck_city_helper
       @search=Search.new;    @search.fcity_code=params[:city_id];    @search.tcity_code="100000000000"

    cityid=params[:city_id]
    if @province and @region.blank? and @city.blank? # is a province id
      next_province=cityid.to_i+10000000000
      @trucks = Truck.any_of([{:status=>"正在配货",:fcity_code.gte=>cityid.to_s,:fcity_code.lt=> next_province.to_s},
          {:status=>"正在配货",:tcity_code.gte=>cityid.to_s,:tcity_code.lt=> next_province.to_s}]).desc(:created_at)
      .paginate(:page=>params[:page]||1,:per_page=>25)
    elsif  @province and @region and @city.blank?  and params[:citytype]!="city" # is a region
    #  @region=params[:city_id]
       next_region=cityid.to_i+100000000
       @trucks=Truck.any_of([{:status=>"正在配货",:fcity_code.gte=>cityid.to_s,:fcity_code.lt=> next_region.to_s},
          {:status=>"正在配货",:tcity_code.gte=>cityid.to_s,:tcity_code.lt=> next_region.to_s}]).desc(:created_at)
      .paginate(:page=>params[:page]||1,:per_page=>25)
    else
    # @region=params[:city_id].slice(0,4)+"00000000"
    @trucks=Truck.any_of([{:status=>"正在配货",:fcity_code=>cityid.to_s},
          {:status=>"正在配货",:tcity_code=>cityid.to_s}]).desc(:created_at)
      .paginate(:page=>params[:page]||1,:per_page=>25)
    end
   #we want to sort the region as the number
    @region_list=Array.new
    $province_tree[@province.to_s].each do |regioncity|     
     @region_list<<[regioncity,$city_code_name[regioncity],get_region_truck_from_count(regioncity),get_region_truck_to_count(regioncity)]
    end
    @region_list.sort_by!{|x| x[2]}.reverse! #now sory by from number  
  
    if @region
      @city_list=Array.new
      $citytree[@province][@region].each do |code,name|
        count=Truck.any_of([{:status=>"正在配货",:fcity_code=>code.to_s},
          {:status=>"正在配货",:tcity_code=>code.to_s}]).count
        @city_list<<[code,name,count]
      end
    #add region statistic here, this is city code same as region code
          count=Truck.any_of([{:status=>"正在配货",:fcity_code=>@region.to_s},
          {:status=>"正在配货",:tcity_code=>@region.to_s}]).count
        @city_list<<[@region,$city_code_name[@region],count]
         @city_list.sort_by!{|x| x[2]}.reverse!
    end
end
  
end
