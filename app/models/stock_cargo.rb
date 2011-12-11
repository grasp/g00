class StockCargo
  #  belongs_to :users
   include Mongoid::Document
   include Mongoid::Timestamps
    #category related
      field :big_category,:type=>String
      field :cate_name,:type=>String
      field :cate_code,:type=>String

      #packakge related
      field :package_name,:type=>String
      field :package_code,:type=>String

      #cargo property and status
      field :cargo_property,:type=>String

      #expired/invalid/normal
      field :stock_status,:type=>String
      
      #weight and bulk
      field :ku_weight,:type=>String
      field :ku_bulk,:type=>String    
      
      field :sent_weight,:type=>Float
      field :sent_bulk,:type=>Float     

      
      #Statistic
      field :valid_cargo,:type=>Integer
      #status
      field :status,:type=>String
      
      #define for search
     field :cangkus
     field :user_id 
     field :company_id
     field :scstatistic_id

end
