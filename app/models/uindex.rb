 # coding: utf-8
class Uindex
  include Mongoid::Document
  include Mongoid::Timestamps
  has_one :user
  has_one:company
  has_one:ustatistic
  has_many :stock_cargo
  has_many :cargo
  has_many :stock_truck
  has_many :truck
  has_many:inquery
  has_many:quote
  #index should be user_id


  
  
  
   
  

end
