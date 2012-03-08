# coding: utf-8
class Quote 
  # belongs_to :cargos
  # belongs_to :trucks
   include Mongoid::Document
   include Mongoid::Timestamps
     #basic infor
      field :price,:type=>Integer
      field :comments,:type=>String
      field :cargo_id
      field :truck_id
      field :truck_user_id
      field :truck_company_id
      field :cargo_user_id
      field :cargo_company_id
      field :user_id

      #status of quotes
      field:status,:type=>String


      # for future usage
      field :ismailed,:type=>Boolean
      field :isaccepted,:type=>Boolean
      
      index [[:cargo_id,Mongo::ASCENDING],[:truck_id,Mongo::ASCENDING]]

      
    validate :check_unique, :on=>:create
  def check_unique
    repeated=Quote.where(:cargo_id=>self.cargo_id,:truck_id=>self.truck_id)
       unless repeated.size==0
      errors.add_to_base("不能重复报价")
      return false
    end
    return true
  end

end
