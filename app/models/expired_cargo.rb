# coding: utf-8
class  ExpiredCargo
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

  #important information
  field :zhuang_addr, :type=>String
  field :zhuang_time, :type=>String
  field :xie_addr, :type=>String
  field :contact, :type=>String
      
  field :price, :type=>String
  field :price_unit, :type=>String
      
  # from site
  field :from_site, :type=>String
  field :priority, :type=>Integer #show priority
      
  #tousu and jubao

      
  # statistic
  field :total_baojia, :type=>Integer
  field :total_xunjia, :type=>Integer
  field :total_match, :type=>Integer
  field :total_click, :type=>Integer
      
  field :cj_truck_id
  field :cj_quote_id
  field :cj_user_id
  field :cj_company_id
      

  field :user_id
  field :user_contact_id
  field :company_id
  field :stock_cargo_id
  
  #below is for phone concern, we need add this two field when we create cargo
  field :mobilephone, :type=>String
  field :fixphone, :type=>String

     
end
