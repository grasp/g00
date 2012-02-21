# coding: utf-8
class TruckLocation
  include Mongoid::Document
  include Mongoid::Timestamps 
  field :truck_id
  field :mphone
  field :paizhao
  field :history,:type=>Array
end
