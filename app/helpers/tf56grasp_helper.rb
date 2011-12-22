# coding: utf-8
module Tf56graspHelper
    def get_first_page_huo
     @admin=User.where("name"=>"admin").first
    a = Mechanize.new
    a.user_agent_alias = 'Mac Safari'
    a.set_proxy(@proxy_server, 1080) if @office==true

   # @log.debug "start to get first page#{start_time}"
    one_page_huo=Array.new
    a.get('http://www.tf56.com/wshy.asp') do |page|
      page.parser().css("html body table table table table table tr").each do |tr|
        one_item_huo=Hash.new
        td_info=Array.new
        url=tr.css("td.hydash a").map { |link| link['href'] }
        unless url.nil?
          url="http://www.tf56.com/"+url[0].to_s
          tr.css("td.hydash").each do |p|
            td_info<<p.content
          end
          if td_info.size==6
            unless td_info[0].blank?
             one_item_huo[:cate_name]=td_info[0].gsub("·","")
            else
              one_item_huo[:cate_name]= "未知货物"
            end
            one_item_huo[:cargo_weight]=td_info[2].chop!
            one_item_huo[:fcity_name]=td_info[3]
            one_item_huo[:tcity_name]=td_info[4]
            #guess city name here
            city_code=CityTree.get_code_from_name(one_item_huo[:fcity_name]) unless  one_item_huo[:fcity_name].nil?
            cal_city=CityTree.get_city_full_path(city_code) unless  city_code.nil?
            one_item_huo[:fcity_code]=city_code
            one_item_huo[:fcity_name]=cal_city

            city_code=CityTree.get_code_from_name(one_item_huo[:tcity_name]) unless  one_item_huo[:tcity_name].nil?
            cal_city=CityTree.get_city_full_path(city_code) unless  city_code.nil?

            one_item_huo[:tcity_code]=city_code
           if (not one_item_huo[:fcity_code].blank?  and not  one_item_huo[:tcity_code].blank?)  
            one_item_huo[:line]=one_item_huo[:fcity_code]+"#"+one_item_huo[:tcity_code]
            one_item_huo[:tcity_name]=cal_city
            
             #fetch out mobile phone and fix phone
             #  one_item_huo[:mobilephone]= one_item_huo[:cate_name].match(/1\d\d\d\d\d\d\d\d\d\d/).to_s
              #   one_item_huo[:fixphone]= one_item_huo[:cate_name].match(/1\d\d\d\d\d\d\d\d\d\d/).to_s
         #   one_item_huo[:created_at]=td_info[5].strip!
         one_item_huo[:created_at]=Time.now
            one_item_huo[:send_date]=1
            # one_item_huo[:updated_at]=Time.now
            one_item_huo[:url]=url.to_s  #keep this url at first , remove after get contact
            one_item_huo[:status]="正在配车"  # for match local
            one_item_huo[:from_site]="tf56"
            one_item_huo[:priority]=200
            one_item_huo[:user_id]=@admin.id
            one_page_huo<<one_item_huo
        end
          end
        end
      end
    end
    #Get contact for each item huo
    one_page_huo.each do |one_item_huo|
      a.get(one_item_huo[:url]) do |page|
        page.parser().css("html body table table table table table table tr").each do |tr|
          td_info=Array.new
          tr.css("td.hytitle").each do |p|
            td_info<<p.content
          end
          if td_info.size==7
            one_item_huo[:comments]=td_info[5]
            if not one_item_huo[:mobilephone].blank? and not one_item_huo[:comments].blank?
             one_item_huo[:mobilephone]=one_item_huo[:comments].match(/1\d\d\d\d\d\d\d\d\d\d/).to_s
             one_item_huo[:fixphone]=one_item_huo[:comments].match(/\[\d\d\d+\]\d\d\d\d\d\d\d+/).to_s
             one_item_huo[:fixphone]=one_item_huo[:fixphone].gsub("[","").gsub("]","-").to_s if one_item_huo[:fixphone]
            end
            one_item_huo.delete(:url) #no use
          end
        end
      end
    end

    return one_page_huo
  end
  def get_first_page_che
    a = Mechanize.new
    a.set_proxy( @proxy_server, '1080') if @office
    one_page_che=Array.new
    a.get('http://www.tf56.com/wscy.asp') do |page|
      page.parser().css("html body table table table table table  table table tr").each do |tr|
        one_item_che=Hash.new
        td_info=Array.new
        url=tr.css("td.hydash a").map { |link| link['href'] }
        unless url[0].nil?
        #  puts "#{url[0].to_s[-5..-1]}"
          url="http://www.tf56.com/"+"TradeCenter/AspData/tCarDetail.asp?iWebBizCarID="+url[0].to_s[-6..-1]
         # puts url
          one_item_che[:url]=url
          one_page_che<<one_item_che
          tr.css("td.hydash").each do |p|
            td_info<<p.content
          end
          if td_info.size==4
          #  one_item_che[:created_at]=td_info[3].strip!  #record created time,seemd not work
          one_item_che[:created_at]=Time.now  #record created time,seemd not work
          end
        end
      end
    end

    one_page_che.each do |one_item_che|
      # puts "start parse che url=#{one_item_che[:url]},one_page_size=#{one_page_che.size}"
      a.get(one_item_che[:url]) do |page|
        raise if page.nil?
        page.parser().css("table").each do |tr|
          td_info=Array.new
          tr.css("td").each do |p|
            td_info<<p.content
          end
          if td_info.size>40 #full size is 54
            one_item_che[:paizhao]=td_info[6] ||"牌照未知"
           # puts " #{one_item_che[:paizhao]}"
            one_item_che[:tcity_name]=td_info[38]
            one_item_che[:fcity_name]=td_info[32]
            city_code=CityTree.get_code_from_name(one_item_che[:fcity_name]) unless  one_item_che[:fcity_name].nil?
            cal_city=CityTree.get_city_full_path(city_code) unless  city_code.nil?
            one_item_che[:fcity_code]=city_code
            one_item_che[:fcity_name]=cal_city
            city_code=CityTree.get_code_from_name(one_item_che[:tcity_name]) unless  one_item_che[:tcity_name].nil?
            cal_city=CityTree.get_city_full_path(city_code) unless  city_code.nil?
            one_item_che[:tcity_code]=city_code
            one_item_che[:tcity_name]=cal_city

            one_item_che[:length]=td_info[24].to_s.delete("米")
            one_item_che[:dunwei]=td_info[18].to_s.delete("吨")

          elsif td_info.size>6 # full size is 16 , only driver phone , is 10
            one_item_che[:driver_phone]=td_info[6]
            one_item_che[:car_phone]=td_info[12] #actully is car owner phone!!
            one_item_che[:status]="正在配货"  # for match local
            one_item_che[:from_site]="tf56"
            one_item_che[:priority]=200
            one_item_che[:send_date]=1
            one_item_che[:huicheng]="003"
          end
         # puts  one_item_che
           one_item_che.delete(:url)
        end

    end
     end
    return  one_page_che
  end

  def get_tf56_grasps
    start_time=Time.now;@huo_succ_counter=0;@huo_fail_counter=0
    @admin=User.where("name"=>"admin").first
    @page_huos=get_first_page_huo

    #insert each huo
    @page_huos.each do |huo|
    huo[:user_id]=@admin.id
    begin
    a=Cargo.new(huo)
    if a.save!
      @cargo=a
      notify
    end
    @huo_succ_counter+=1 
    rescue
     # puts $@
      @huo_fail_counter+=1
    end
    end
     @huo_time=Time.now-start_time
   start_time=Time.now;@che_succ_counter=0;@che_fail_counter=0
    @page_ches=get_first_page_che
        @page_ches.each do |che|
        che[:user_id]=@admin.id
    begin
    a=Truck.new(che)
    @che_succ_counter+=1 if a.save
    rescue
      @che_fail_counter+=1
    end
   end
     @che_time=Time.now-start_time
     a=GraspRecord.new({:diff_che=> @che_succ_counter,:diff_huo=> @huo_succ_counter,
        :cycle_che=>0,:cycle_huo=>0,
        :cost_time=>@huo_time+@che_time,
        :fail_counter=>@huo_fail_counter+@che_fail_counter,
        :miss_field_huo=>0,:miss_field_che=>0,
        :repeat_huo=>@huo_fail_counter,:repeat_che=>@che_fail_counter,
        :cargostatus=>"notexpired",  :truckstatus=>"notexpired",:from_site=>"tf56"})

     @grasp=GraspRecord.all.order(:created_at.desc).first
  end
end