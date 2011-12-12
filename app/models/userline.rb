class Userline
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, :type => String
  field :fcityid, :type => String
  field :tcityid, :type => String
  field :fcityname, :type => String
  field :tcityname, :type => String
  field :line, :type => String
end
