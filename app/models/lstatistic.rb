class Lstatistic
  include Mongoid::Document
  include Mongoid::Timestamps
      field :line,:type=>String
      field :valid_cargo,:type=>Integer
      field :valid_truck,:type=>Integer
      field :total_cargo,:type=>Integer
      field :total_truck,:type=>Integer
     # timestamps!  
end
