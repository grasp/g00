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
      field :user_id

end
