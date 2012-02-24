 # coding: utf-8
class Concerncityc
   include Mongoid::Document
   include Mongoid::Timestamps
 
     field :city, :type=>String
     field :emaillist, :type=>Array
     field :smslist, :type=>Array
    index :city, unique: true#, drop_dups: true
end
