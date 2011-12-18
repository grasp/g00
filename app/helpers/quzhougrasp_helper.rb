# coding: utf-8
module QuzhougraspHelper

  def get_first_page_quzhou
    a = Mechanize.new
    a.user_agent_alias = 'Mac Safari'
    a.set_proxy(@proxy_server, 1080)  if @office
    start_time=Time.now
    # puts "start to get first page#{start_time}"
    page_huo=Array.new
    page_che=Array.new
    3.downto(1) do |i|
      a.get("http://211.140.153.81/wl/UserQueryData.jsp?offset=#{i}&likestr=") do |page|
        page.parser().css("table table tr").each do |tr|
          item_info=Array.new
          tr.css("td").each do |p|
            item_info<<p.content
          end
          if item_info.size >5
            one_item=Hash.new
            item_info[0].strip!
            #  puts "#{item_info[0]},size=#{item_info[0].size}"
            if item_info[0].to_s=="货物"
              one_item[:cate_name]=item_info[1] ||"面谈"
              one_item[:cate_name]="面谈" if one_item[:cate_name].to_s.size<2
              #to deduce length for display and advers
              one_item[:cate_name]=one_item[:cate_name].to_s[0,10] if one_item[:cate_name].to_s.size>15 
              one_item[:fcity_name]=item_info[2]
              one_item[:tcity_name]=item_info[3]
              city_code= cal_city=nil
              city_code=CityTree.get_code_from_name(one_item[:fcity_name]) unless  one_item[:fcity_name].nil?
              cal_city=CityTree.get_city_full_path(city_code) unless  city_code.nil?
              one_item[:fcity_code]=city_code
              one_item[:fcity_name]=cal_city
              city_code=CityTree.get_code_from_name(one_item[:tcity_name]) unless  one_item[:tcity_name].nil?
              cal_city=CityTree.get_city_full_path(city_code) unless  city_code.nil?
              one_item[:tcity_code]=city_code
              one_item[:tcity_name]=cal_city
              one_item[:cargo_weight]=item_info[4]||"0"+item_info[5]||"0"
              one_item[:cargo_weight]=one_item[:cargo_weight].chop!
              one_item[:price]=item_info[6]
              one_item[:price_unit]=item_info[7]
              one_item[:comments]=item_info[9]
              one_item[:need_che_length]=item_info[8]
              one_item[:contact_phone]=item_info[11]
               one_item[:mobilephone]=item_info[11].match(/1\d\d\d\d\d\d\d\d\d\d/).to_s
                one_item[:fixphone]=item_info[11].match(/\d\d\d+-\d\d\d\d\d\d\d+/).to_s  
              if item_info[11].size==7
                item_info[11]="0570-"+item_info[11]
                #   puts "item_info[11]=#{item_info[11]}"
              end
              #  one_item[:created_at]=item_info[12]
              one_item[:created_at]=Time.now
              one_item[:send_date]=1
              # one_item[:updated_at]=Time.now
              one_item[:status]="正在配车"  # for match local
              one_item[:from_site]="quzhou"  #used for show which template
              page_huo<<one_item
            end
            if item_info[0].to_s=="空车"
              one_item[:fcity_name]=item_info[2]
              one_item[:tcity_name]=item_info[3]
              city_code=CityTree.get_code_from_name(one_item[:fcity_name]) unless  one_item[:fcity_name].nil?
              cal_city=CityTree.get_city_full_path(city_code) unless  city_code.nil?
              one_item[:fcity_code]=city_code
              one_item[:fcity_name]=cal_city
              city_code=CityTree.get_code_from_name(one_item[:tcity_name]) unless  one_item[:tcity_name].nil?
              cal_city=CityTree.get_city_full_path(city_code) unless  city_code.nil?
              one_item[:tcity_code]=city_code
              
              one_item[:line]= one_item[:fcity_code]=city_code+"#"+  one_item[:tcity_code]
              one_item[:tcity_name]=cal_city
              one_item[:dunwei]=item_info[4]||"0"+item_info[5]||"0"
              one_item[:length]=item_info[8]||"0"+"米"
              one_item[:truck_shape]=item_info[9]
              one_item[:price]=item_info[6]||"0"
              one_item[:price_unit]=item_info[7]
              #默认衢州区号
              if item_info[11].size==7
                item_info[11]="0570-"+item_info[11].to_s
              end
              one_item[:contact_phone]=item_info[11]
              #    one_item[:created_at]=item_info[12]
              one_item[:created_at]=Time.now
              one_item[:paizhao]= "未知牌照"
              one_item[:status]="正在配货"  # for match local
              one_item[:from_site]="quzhou"
              one_item[:send_date]=1
              one_item[:huicheng]="003"
              page_che<<one_item
            end
          end
        end
      end
    end
    end_time=Time.now
    [page_huo,page_che]
  end
  def  get_quzhou_grasps
    start_time=Time.now
    @admin=User.where("name"=>"admin").first

    grasp= get_first_page_quzhou
    start_time=Time.now;@huo_succ_counter=0;@huo_fail_counter=0;@che_succ_counter=0;@che_fail_counter=0
    @page_huos=grasp[0]
    @page_ches=grasp[1]
    #insert each huo
    @page_huos.each do |huo|
      huo[:user_id]=@admin.id
      # puts huo
      begin
        a=Cargo.new(huo)
        if a.save!
        @huo_succ_counter+=1 
        @cargo=a
        notify
        end
      rescue
        @huo_fail_counter+=1
      end
    end
    @huo_time=Time.now-start_time
    @page_ches.each do |che|
      che[:user_id]=@admin.id
      # puts che
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
