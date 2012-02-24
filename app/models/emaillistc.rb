 # coding: utf-8
class Emaillistc
   include Mongoid::Document
   include Mongoid::Timestamps
 
     field :email, :type=>String
     field :cargolist, :type=>Array
     field :csize, :type=>Integer
     index :email, unique: true#, drop_dups: true
end
