# coding: utf-8
class ExpiredInquery 
        include Mongoid::Document
  #belongs_to :trucks
  #belongs_to :cargos

    field :price,:type=>Integer
    field :comments,:type=>String

      #status
    field :status,:type=>String

   # foreign data
      field :cargo_id,:type=>String
      field :truck_id,:type=>String
      field :truck_company_id,:type=>String
      field :truck_user_id,:type=>String
      field :cargo_company_id,:type=>String
      field :cargo_user_id,:type=>String
      field :user_id,:type=>String
      
   #feature usage
      field :ismailed,:type=>Boolean
      field :isaccepted,:type=>Boolean
     # timestamps!

end
