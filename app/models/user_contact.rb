class UserContact 
include Mongoid::Document
include Mongoid::Timestamps
  # belongs_to :users
  
      field :name,:type=>String
      field :email,:type=>String
      field :mobilephone,:type=>String
      field :quhao,:type=>String
      field :fixphone,:type=>String
      field :QQ,:type=>String
      field :website,:type=>String
      field :city_name,:type=>String
      field :city_code,:type=>String
      field :address,:type=>String
      field :company_id
      field :user_id
 
end
