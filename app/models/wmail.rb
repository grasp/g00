#coding:utf-8
class Wmail
  include Mongoid::Document
   include Mongoid::Timestamps
  field :to, :type => String
  field :from, :type => String
  field :body, :type => String
  field :subject, :type => String
  field :fromu, :type => String
  field :fromname, :type => String
  field :mailtype,:type => String #invite,cargo,truck,or others 
  
  index ([[:from,Mongo::ASCENDING],[:to,Mongo::ASCENDING],[:created_at,Mongo::ASCENDING]])
 
end
