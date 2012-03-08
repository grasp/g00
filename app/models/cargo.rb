# coding: utf-8
class  Cargo
  include Mongoid::Document
  include Mongoid::Timestamps
  include CitiesHelper
  include CargosHelper
  # cattr_reader :per_page
  # @@per_page = 20      
  # cargo self info
  field :cargo_weight, :type=>String
  field :cargo_zuhuo, :type=>String
  field :cargo_bulk, :type=>String
  field :send_date, :type=>String
  field :comments, :type=>String
  field :status, :type=>String
  field :is_self,:type=>String

  #for not go back to find stock_cargo
  field :cate_name, :type=>String
  field :package_name, :type=>String
  field :big_category, :type=>String

  # important line info
  field :line, :type=>String
  field :fcity_name, :type=>String
  field :tcity_name, :type=>String
  field :fcity_code, :type=>String
  field :tcity_code, :type=>String   



  #below is for phone concern, we need add this two field when we create cargo
  field :mobilephone, :type=>String
  field :fixphone, :type=>String
  
   field :user_id, :type=>String
  field :contact, :type=>String
  field :user_contact_id
  
  field :company
  field :company_id
  
  field :price, :type=>String
  field :price_unit, :type=>String   
  
  # from site
  field :from_site, :type=>String
  field :priority, :type=>Integer #show priority
  field :timetag    
  field :posted, :type=>String
  
  #important information
  field :zhuang_addr, :type=>String
  field :zhuang_time, :type=>String
  field :xie_addr, :type=>String
      
  # statistic
  field :total_baojia, :type=>Integer
  field :total_xunjia, :type=>Integer
  field :total_match, :type=>Integer
  field :total_click, :type=>Integer
  field :tousu, :type=>Integer
      
  field :cj_truck_id
  field :cj_quote_id
  field :cj_user_id
  field :cj_company_id
      
  field :stock_cargo_id
  


  index ([[:from_site,Mongo::ASCENDING],[:updated_at,Mongo::ASCENDING],[:status,Mongo::ASCENDING],[:fcity_code,Mongo::ASCENDING],[:tcity_code,Mongo::ASCENDING]])
  validates_presence_of :fcity_code,:tcity_code   #remove cate_name, could be empty from grasp
 
 before_create:check_unique
  after_create:notify,:expire
  def check_unique
   # repeated=Cargo.where(:cate_name=>self.cate_name,:line=>self.line,:user_id=>self.user_id,:status=>"正在配车",
   #   :contact=>self.contact,:comments=>self.comments,:from_site=>self.from_site ).count 

        repeated=Cargo.where(:cate_name=>self.cate_name,:line=>self.line,:user_id=>self.user_id,:status=>"正在配车",
     :contact=>self.contact,:from_site=>self.from_site ,:mobilephone=>self.mobilephone,:fixphone=>self.fixphone).count 
      puts "repeated=#{repeated}"
  if  repeated > 0
      return false
  end
      return true
  end
  def expire
 begin
    ActionController::Base.new.expire_fragment("cargos_allcity_1")
    ActionController::Base.new.expire_fragment("cargos_allcity_1")
    ActionController::Base.new.expire_fragment("provincecargo")
    ActionController::Base.new.expire_fragment("users_center_#{self.user_id}")    
    city_level(self.fcity_code)[1].each do |city|
      ActionController::Base.new.expire_fragment("cargo_city_#{city}_")
      ActionController::Base.new.expire_fragment("cargo_city_#{city}_city")
    end
    city_level(self.tcity_code)[1].each do |city|
      ActionController::Base.new.expire_fragment("cargo_city_#{city}_")
      ActionController::Base.new.expire_fragment("cargo_city_#{city}_city")#this is for region code is same as city code issue
    end
 rescue
  puts "expire cargo fail"
 end
  end
  
     
end
