class Ustatistic
    include Mongoid::Document
    include Mongoid::Timestamps     
      field :total_stock_cargo,:type=>Integer
      field :total_stock_truck,:type=>Integer
      field :total_cargo,:type=>Integer      
      field :total_truck,:type=>Integer
      field :valid_cargo,:type=>Integer
      field :valid_truck,:type=>Integer
      field :total_line,:type=>Integer
      field :total_driver,:type=>Integer
      field :total_custermer,:type=>Integer
      field :status,:type=>String
      field :todaymail,:type=>Integer
      field :totalmail,:type=>Integer
      field :user_id,:type=>String
      field :user_email,:type=>String
      field :user_name,:type=>String
      
      index ([[:user_id,Mongo::ASCENDING],[:user_email,Mongo::ASCENDING],[:user_name,Mongo::ASCENDING]])
  

end
