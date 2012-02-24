# coding: utf-8
class City
  include Mongoid::Document
  include Mongoid::Timestamps 
  #include Mongoid::Geo
 # include Mongoid::Spacial::Document
  
  field :name, :type=>String
  field :code, :type=>String
  field :lat, :type=>Float
  field :lng, :type=>Float
  field :coordinates, :type => Array
  field :loc, :type => Array
  field :address
 # field :source,            type: Array,    spacial: true
  # set return_array to true if you do not want a hash returned all the time
 # field :mouth,             type: Array,    spacial: {lat: :latitude, lng: :longitude, return_array: true }

  # simplified spacial indexing
  # you can only index one point in mongodb version below 1.9
  # if you want something besides the defaults {bit: 24, min: -180, max: 180} just set index to the options on the index
 # spacial_index :source
  
 # def gmaps4rails_address
 #   "#{self.address}, #{self.city.name}, #{self.state.name}" 
 # end
  
      def gmaps4rails_infowindow
      # add here whatever html content you desire, it will be displayed when users clicks on the marker
       "this is a test #{code},#{name}"
    end

end
