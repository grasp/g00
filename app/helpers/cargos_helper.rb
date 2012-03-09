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
      #  @contact=  @cargo.comments  if @cargo[:from_site]=="haoyun56"
      #  @contact=  @cargo.comments  if @cargo[:from_site]=="56135"
      #  @contact=  @cargo.comments+"联系电话:"+@cargo.contact  if @cargo[:from_site]=="56qq"
      #  @contact=  @cargo.comments  if @cargo[:from_site]=="tf56"
      #  @contact=  @cargo.contact_phone if @cargo[:from_site]=="quzhou"
      @jubao_counter=Jubao.where(:belongid=>@cargo.id).count
      if @cargo[:from_site]=="local"
        if @cargo.stock_cargo_id
          @stock_cargo=StockCargo.find(@cargo.stock_cargo_id)
          @user=User.find(@cargo.user_id)
        end
      else
        @show_other_cargo=(@cargo.contact||"")+"  "+(@cargo.comments||"")+"  "+(@cargo.timetag||"")+""
      end

      if @line_ad.blank?

      end
    end
  end

  def     cargo_allcity_helper
    @search=Search.new;    @search.fcity_code="100000000000";    @search.tcity_code="100000000000"
    @cargos=Cargo.where(:status=>"正在配车") .desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
    # @cargos=Cargo.all.desc(:created_at).paginate(:page=>params[:page]||1,:per_page=>25)
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
 
  def notify
    log=Logger.new("notify.log")
    if self #this is under local database mode
      cargo=self 
    else
      cargo=@cargo
    end
    #find out email list of send city
    email_list= Array.new 
    sms_list= Array.new 
    concerncity=Concerncityc.where(:city=>cargo.fcity_code).first    
    email_list=email_list.concat(concerncity.emaillist)  unless concerncity.blank?

    #find out sms list of send city
    sms_list=sms_list.concat(concerncity.smslist) unless concerncity.blank?
    if not is_region?(cargo.fcity_code)  #is city then to notify the parent region subscribe also
      parentcity=Concerncityc.where(:city=>cargo.fcity_code.slice(0,4)+"00000000").first  
      unless parentcity.blank?
        email_list=email_list.concat(parentcity.emaillist)
        sms_list=sms_list.concat(parentcity.smslist)
      end
    end

    get_parent_line(cargo.line).each do |eachline|    #need consider parent line concern
      #puts "try update line #{eachline}"
      concernline=Concernlinec.where(:line=>eachline).first         
      email_list=email_list.concat(concernline.emaillist|| Array.new)  unless concernline.blank?
      # sms_list=sms_list.concat(concernline.smslist || Array.new) unless concernline.blank?
    end

    concernuser=Concernuserc.where(:userid=>cargo.user_id).first    
    email_list=email_list.concat(concernuser.emaillist || Array.new ) unless concernuser.blank?
    # sms_list=sms_list.concat(concernuser.smslist || Array.new ) unless concernuser.blank?
    

    concernphone1=Concernphonec.where(:mobilephone=>cargo.mobilephone).first    
    email_list=email_list.concat(concernphone1.emaillist || Array.new) unless concernphone1.blank?
    # sms_list=sms_list.concat(concernphone1.smslist || Array.new) unless concernphone1.blank?
    concernphone2=Concernphonec.where(:fixphone=>cargo.fixphone).first 
    
    if concernphone2
      email_list=email_list.concat(concernphone2.emaillist )
      #sms_list=sms_list.concat(concernphone2.smslist)
    end
    
    #update only do once 
    begin
      update_notify_list(email_list,sms_list,cargo)
    rescue
      puts $@
    end
  end
  
  def update_notify_list(email_list,sms_list,cargo)
    #  log=Logger.new("notify.log")
    # Emaillistc.destroy_all
    email_list.uniq!
    puts "need update list size=#{email_list.size}"
    # sms_list.uniq!
    email_list.each do |email|
      #  puts " hanle #{email} in email list"
      emailsubscribe=Emaillistc.where(:email=>email).first      
      user=User.where(:email=>email).first 
      ustatistic=Ustatistic.where(:user_email=>email).first
      #  puts "notify #{user.name},todaymail=#{ustatistic.todaymail}" if user
      #  puts "ustatistic.todaymail=#{ustatistic.todaymail}"
      #  puts "ustatistic.totalmail=#{ustatistic.totalmail}"
      ustatistic.todaymail=0 if ustatistic.todaymail.blank?
      if ustatistic.todaymail < 20 || email=="hunter.wxhu@gmail.com"
        unless user.id.to_s==cargo.user_id.to_s
          unless emailsubscribe.blank?
            #  new_cargolist=Array.new
            new_cargolist=emailsubscribe.cargolist||Array.new
            # puts "original cargo list=#{emailsubscribe.cargolist},size=#{new_cargolist.size}"
            new_cargolist<<cargo.id.to_s
            #   puts "new cargo list=#{ new_cargolist},size=#{new_cargolist.size}"
            new_cargolist.uniq!
            #   puts "uniq cargo list=#{ new_cargolist},size=#{new_cargolist.size}"
            emailsubscribe.update_attributes(:cargolist=>new_cargolist,:csize=>new_cargolist.size)
          
          else
            #   puts"create emaillist for new user"
            emailsubscribe= Emaillistc.new
            emailsubscribe.email=email
            emailsubscribe.cargolist=[cargo.id.to_s]
            new_cargolist=[cargo.id.to_s]
            emailsubscribe.csize=1
            emailsubscribe.save
            emailsubscribe.update_attributes(:email=>email,:cargolist=>new_cargolist,:csize=>1)
          end
  
        end
      else
        puts "mail sent >10 in one day"
      end
      puts "end of email list handle"
      #update each sms's cargo list
      if false  #not use on now
        sms_list.each do |sms|
          smssubscribe= Smslistc.where(:phone=>sms).first
          unless   smssubscribe.blank?
            Smslistc.where(:phone=>sms).first.push(:cargolist,cargo.id.to_s)
          else
            smssubscribe=Smslistc.new  
          end
        end
      end

    end
  end
  def fabu_helper
    check=false
    @quickfabu=Hash.new
    @quickfabu[:from]=params[:from]
    @quickfabu[:to]=params[:to]
    @quickfabu[:contact]=params[:contact]
    @quickfabu[:cargoname]=params[:cargoname]
    @quickfabu[:chelength]=params[:chelength]
    @quickfabu[:weight]=params[:weight]
    @quickfabu[:send_date]=params[:send_date]
    @quickfabu[:zuhuo]=params[:zuhuo]
    @quickfabu[:comments]=params[:comments]

    mphone=@quickfabu[:contact].match(/(^|\D)\d\d\d\d\d\d\d\d\d\d\d($|\D)/)
    mphone=mphone.to_s.match(/\d\d\d\d\d\d\d\d\d\d\d/) if mphone
    fixphone=@quickfabu[:contact].match(/(^|\D)\d\d\d(-)\d\d\d\d\d\d\d(\d)($|\D)/)
    fixphone=fixphone.to_s.match(/\d\d\d(\d)(-|-)\d\d\d\d\d\d\d(\d)/) if fixphone
    fcity_code=CityTree.get_code_from_name(params[:from])
    tcity_code=CityTree.get_code_from_name(params[:to])
    if @quickfabu[:from].size==0 || @quickfabu[:to].size==0
      flash[:notice]="发布失败了，你不能发布一个空的省市"
    elsif @quickfabu[:contact].size==0 
      flash[:notice]="发布失败了，联系人没有填写"
    elsif (not(@quickfabu[:contact].match(/(^|\D)\d\d\d\d\d\d\d\d\d\d\d($|\D)/)||@quickfabu[:contact].match(/(^|\D)\d\d\d(-)\d\d\d\d\d\d\d(\d)($|\D)/)) )
      flash[:notice]="发布失败了，联系人电话没有写或者格式不对"
    elsif @quickfabu[:from].size>20 || @quickfabu[:to].size>20
      flash[:notice]="发布失败了，省市数据太长了"
    elsif @quickfabu[:cargoname].size>20 || @quickfabu[:chelength].size>10
      flash[:notice]="发布失败了，货物名字或者车长太长"
    elsif @quickfabu[:contact].size>30 || @quickfabu[:comments].size>100
      flash[:notice]="发布失败了，联系或者备注太长"
    elsif fcity_code.nil?
      flash[:notice]="发布失败了，不能识别出发的省市,试试完整的路径如浙江省杭州市西湖区"
    elsif tcity_code.nil?
      flash[:notice]="发布失败了，不能识别到达的省市,试试完整的路径如江苏省苏州市常熟市"
    else
      check=true
    end
    
    #now save to cargo
    if check

    begin
    @cargo=Cargo.create!(:fcity_code=>fcity_code,:tcity_code=>tcity_code,:fcity_name=>params[:from],:tcity_name=>params[:to],
      :cargo_weight=>params[:weight],:send_date=>params[:send_date], :comments=>params[:comments] +"求"+params[:chelength]+"米车",
    :cate_name=>params[:cargoname],:status=>"正在配车",:user_id=>session[:user_id]||"4dc7338c7516fd590b000001",:line=>fcity_code+"#"+tcity_code,
     :mobilephone=>mphone,:fixphone=>fixphone,:from_site=>"local",:contact=>params[:contact],:cargo_zuhuo=>params[:zuhuo]);
    flash[:notice]="发布成功了！，祝你生意兴隆！"
    rescue
       flash[:notice]="发布失败了，可能是重复发布了"
       puts $@
    end

    
    end
  end 
  

end