class Scan 
    cattr_reader :per_page
     @@per_page = 20
    include Mongoid::Document
    include Mongoid::Timestamps
      field :total_user,:type=>Integer
      field :total_stock_truck,:type=>Integer
      field :total_stock_cargo,:type=>Integer
      field :idle_stock_truck,:type=>Integer
      field :idle_stock_cargo,:type=>Integer
      field :total_cargo,:type=>Integer
      field :total_truck,:type=>Integer
      field :valid_cargo,:type=>Integer
      field :valid_truck,:type=>Integer
      field :expired_cargo,:type=>Integer
      field :expired_truck,:type=>Integer
      field :chenjiao_truck,:type=>Integer
      field :chenjiao_cargo,:type=>Integer
      field :total_line,:type=>Integer
      field :total_company,:type=>Integer
      field :cost_time,:type=>String
      field :user_id
      # timestamps!
end
