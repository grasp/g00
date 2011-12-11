 # coding: utf-8
class City
   include Mongoid::Document
   include Mongoid::Timestamps
 

     field :name, :type=>String
     field :code, :type=>String

end
