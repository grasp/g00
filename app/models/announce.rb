class Announce
  include Mongoid::Document
     include Mongoid::Timestamps
  field :title, :type => String
  field :url, :type => String
end
