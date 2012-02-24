 # coding: utf-8
class Concernlinec
   include Mongoid::Document
   include Mongoid::Timestamps
 
     field :line, :type=>String
     field :emaillist, :type=>Array
     field :smslist, :type=>Array
     index :line, unique: true#, drop_dups: true
end
