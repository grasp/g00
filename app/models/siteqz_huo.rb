class SiteqzHuo
   include Mongoid::Document
   include Mongoid::Timestamps
     cattr_reader :per_page
     @@per_page = 3
    # belongs_to :users
   #  has_many :quotes
    # has_many :inqueries
   #  has_one :cstatistic 
   
   # cargo self info
      field :cargo_weight,:type=>String
      field :cargo_zuhuo,:type=>String
      field :cargo_bulk,:type=>String
      field :send_date,:type=>String
      field :comments,:type=>String
      field :status,:type=>String

      #for not go back to find stock_cargo
      field :cate_name,:type=>String
      field :package_name,:type=>String
      field :big_category,:type=>String

      # important line info
      field :line,:type=>String
      field :fcity_name,:type=>String
      field :tcity_name,:type=>String
      field :fcity_code,:type=>String
      field :tcity_code,:type=>String      


      #future usage
      field :pingjia_id,:type=>String
      field :cstatistic_id,:type=>String
      
      # for compatible local model
      embeds_one :users
      
      
   #  timestamps!
end
