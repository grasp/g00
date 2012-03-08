 # coding: utf-8
class RoomContact
   include Mongoid::Document
   include Mongoid::Timestamps
 
     field :room, :type=>String
     field :contact,:type=>String
     field :from,:type=>String      
    validates_uniqueness_of :room ,:message=>"该房间已经存在."
end
