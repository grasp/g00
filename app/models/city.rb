 # coding: utf-8
class City
   include Mongoid::Document
   include Mongoid::Timestamps 
   

     field :name, :type=>String
     field :code, :type=>String
     field :lat, :type=>String
     field :lng, :type=>String
     field :coordinates, :type => Array
     field :address
end
