class Jubao
  include Mongoid::Document
      include Mongoid::Timestamps
  field :jubaotype, :type => String
  field :belongid, :type => String
  field :username, :type => String
  field :fromip, :type => String
  field :fakereason, :type => String
end
