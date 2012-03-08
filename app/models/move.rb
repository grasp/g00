# To change this template, choose Tools | Templates
# and open the template in the editor.
class Move 
    include Mongoid::Document
    include Mongoid::Timestamps
      field :datehour,:type=>String
      field :expired_cargo,:type=>Integer
      field :expired_truck,:type=>Integer
      field :expired_quote,:type=>Integer
      field :expired_inquery,:type=>Integer
      field :cost_time,:type=>String
     field :user_id
      #timestamps!
end
