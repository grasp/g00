# coding: utf-8
class Truck 
  include Mongoid::Document
  include Mongoid::Timestamps
    include CitiesHelper
  #belongs_to :users
  #belongs_to :stock_trucks
  #has_many :inqueries
  #has_many :quotes
  
  #repeat stock_truck info for not go back search
      field  :paizhao,:type=>String
      field  :dunwei,:type=>String
      field  :length,:type=>String
      field  :shape,:type=>String
      field  :usage,:type=>String
      field  :driver_name,:type=>String
      field  :driver_phone,:type=>String
      field  :car_phone,:type=>String

      #truck info
      field  :send_date,:type=>String
      field  :status,:type=>String
      field  :comments,:type=>String
      field  :huicheng,:type=>String
      field  :contact,:type=>String

  
     field  :mobilephone,:type=>String
     field  :fixphone,:type=>String
      #line info
      field  :line,:type=>String
      field  :fcity_name,:type=>String
      field  :tcity_name,:type=>String
      field  :fcity_code,:type=>String
      field  :tcity_code,:type=>String    

      
      field :user_name,:type=>String 
      field :company_name,:type=>String     

       
      #for future usage
      field  :truck_pingjia_id
      field  :truck_status_id
      field  :tstatistic_id 
      
      field :price,:type=>String
      field :price_unit,:type=>String

     # add more le
     field :from_site,:type=>String
    #statistic related
     field :total_baojia,:type=>Integer
     field :total_xunjia,:type=>Integer
     field :total_match,:type=>Integer
     field :total_click,:type=>Integer
   
      #chenjiao record   
      field :cj_cargo_id
      field :cj_quote_id
      field :cj_user_id
      field :cj_company_id
      
      # external search
      field  :company_id
      field  :user_id
      field  :stock_truck_id
      field  :user_contact_id
      index ([[:from_site,Mongo::ASCENDING],[:updated_at,Mongo::ASCENDING],[:status,Mongo::ASCENDING],[:fcity_code,Mongo::ASCENDING],[:tcity_code,Mongo::ASCENDING]])
  before_create:check_unique
  after_save:expire
       
      
    def check_unique
   if self.from_site!="quzhou"
    repeated=Truck.where(:paizhao=>self.paizhao,:line=>self.line,:user_id=>self.user_id,:status=>"正在配货",
            :comments=>self.comments,:contact=>self.contact,:from_site=>self.from_site).count
   else
        repeated=Truck.where(:line=>self.line,:user_id=>self.user_id,:status=>"正在配货",
            :comments=>self.comments,:contact=>self.contact,:from_site=>self.from_site).count
   end
   # puts "repeated.size=#{repeated.size}"
    unless repeated==0
       errors.add(:base,"不能重复发布车源信息")
      return false
    end
    return true
     end
     
     def expire
    controller_base=ActionController::Base.new
    controller_base.expire_fragment("trucks_allcity_1")
    controller_base.expire_fragment("trucks_allcity_1")
    controller_base.expire_fragment("provincetruck")
    controller_base.expire_fragment("users_center_#{self.user_id}")    
    unless self.fcity_code.blank?
    city_level(self.fcity_code)[1].each do |city|
     controller_base.expire_fragment("truck_city_#{city}_")
     controller_base.expire_fragment("truck_city_#{city}_city")
    end
    end
    unless self.tcity_code.blank?
    city_level(self.tcity_code)[1].each do |city|
      controller_base.expire_fragment("truck_city_#{city}_")
      controller_base.expire_fragment("truck_city_#{city}_city")
    end
    end
  end
 
end
