# coding: utf-8
class StockTruck 
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Spacial::Document
  #belongs_to :users
  # has_many :trucks
  #stock truck basic info
  field :paizhao,:type=>String
  field :dun_wei,:type=>String
  field :che_length,:type=>String
  field :truck_usage,:type=>String
  field :truck_shape,:type=>String
  field :truck_gps,:type=>String
  field :is_self,:type=>String
  field :favo_city,:type=>String
  field :favo_line,:type=>String

  #Manufacture info
  field :truck_pinpai,:type=>String
  field :truck_xinghao,:type=>String
  field :truck_year,:type=>String

  #driver info
  field :driver_name,:type=>String
  field :driver_phone,:type=>String
      
  #owner info
  field :owner_name,:type=>String
  field :owner_phone,:type=>String
      
  #owner info
  field :bis_name,:type=>String
  field :bis_phone,:type=>String

  # contact inforamtion
  field :car_phone,:type=>String
  field :company_id
  field :user_id
  
  field :comments,:type=>String
      
  #Statistic
  field :valid_truck,:type=>Integer
  field :total_truck,:type=>Integer
  field :expired_truck,:type=>Integer

  #status
  field :status,:type=>String
  # for feature usage
  field :truck_license_id
  field :truck_owner_id
      
  field :bind , :type=>Boolean
  field :lat, :type=>Float
  field :lng, :type=>Float
  field :speed, :type=>Float
  field :timgtag
  field :loc,:type=>Array,  spacial: true
  field :report_at
  
  #to identify group    
  field :truckgroup_id
  field :group
  spacial_index :loc
  validates_uniqueness_of :paizhao ,:message=>"该牌照车子已经存在."

end
