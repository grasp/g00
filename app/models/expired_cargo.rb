# coding: utf-8
class  ExpiredCargo
     include Mongoid::Document
     include Mongoid::Timestamps
         cattr_reader :per_page
     @@per_page = 20
    # belongs_to :users
   #  has_many :quotes
    # has_many :inqueries
   #  has_one :cstatistic 
      
   # cargo self info
      field :cargo_weight, :type=>String
      field :cargo_zuhuo, :type=>String
      field :cargo_bulk, :type=>String
      field :send_date, :type=>String
      field :comments, :type=>String
      field :status, :type=>String

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
      
      field :stock_cargo_id
      field :user_contact_id

      #important information
      field :zhuang_addr, :type=>String
      field :zhuang_time, :type=>String
      field :xie_addr, :type=>String

      
      field :price, :type=>String
      field :price_unit, :type=>String
      
  # from site
      field :from_site, :type=>String
     
    # statistic
      field :total_baojia, :type=>Integer
      field :total_xunjia, :type=>Integer
      field :total_match, :type=>Integer
      field :total_click, :type=>Integer
      
      field :cj_truck_id
      field :cj_quote_id
      field :cj_user_id
      field :cj_company_id
      
      # for contact
       field :user_id
      field :company_id
      
        #future usage
      embeds_many :pingjias
      field :cstatistic_id
      

     
end
