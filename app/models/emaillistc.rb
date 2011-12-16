 # coding: utf-8
class Emaillistc
   include Mongoid::Document
   include Mongoid::Timestamps
 
     field :email, :type=>String
     field :cargolist, :type=>Array
     index :email, unique: true
end
