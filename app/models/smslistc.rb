 # coding: utf-8
class Smslistc
   include Mongoid::Document
   include Mongoid::Timestamps
 
     field :phone, :type=>String
     field :cargolist, :type=>Array
     index :phone, unique: true
end
