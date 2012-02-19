class Sitedatum
  include Mongoid::Document
  include Mongoid::Timestamps
  field :ie6, :type => Integer
  field :ie7, :type => Integer
  field :ie8, :type => Integer
  field :noneie, :type => Integer
  field :loginuser, :type => Integer
  field :cargoshow, :type => Integer
  field :truckshow, :type => Integer
   field :spider, :type => Integer
   field :msent, :type => Integer
   field :msent_today, :type => Integer
   field :from_mail, :type => Integer
end
