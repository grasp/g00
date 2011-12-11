# coding: utf-8
class ExpiredQuote 
  # belongs_to :cargos
  # belongs_to :trucks
   include Mongoid::Document
     #basic infor
      field :price,:type=>Integer
      field :comments,:type=>String
      field :cargo_id,:type=>String
      field :truck_id,:type=>String
      field :truck_user_id,:type=>String
      field :truck_company_id,:type=>String
      field :cargo_user_id,:type=>String
      field :cargo_company_id,:type=>String
      field :user_id,:type=>String

      #status of quotes
      field:status,:type=>String


      # for future usage
      field :ismailed,:type=>Boolean
      field :isaccepted,:type=>Boolean
      

      #timestamps!

end
