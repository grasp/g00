# coding: utf-8
class City
  include Mongoid::Document
  include Mongoid::Timestamps 
  include Gmaps4rails::ActsAsGmappable
  #include Mongoid::Geo
  include Mongoid::Spacial::Document
  acts_as_gmappable :process_geocoding => false
  
  field :name, :type=>String
  field :code, :type=>String
  field :lat, :type=>String
  field :lng, :type=>String
  field :coordinates, :type => Array
  field :address
  field :source,            type: Array,    spacial: true

  # set return_array to true if you do not want a hash returned all the time
  field :mouth,             type: Array,    spacial: {lat: :latitude, lng: :longitude, return_array: true }

  # simplified spacial indexing
  # you can only index one point in mongodb version below 1.9
  # if you want something besides the defaults {bit: 24, min: -180, max: 180} just set index to the options on the index
  spacial_index :source
end
