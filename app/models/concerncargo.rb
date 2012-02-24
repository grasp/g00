#coding:utf-8
class Concerncargo
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, :type => String
  field :city, :type => Array
  field :line, :type => Array
  field :phone, :type => Array
  field :userid, :type => Array
  field :status, :type => String
  
  validates_uniqueness_of :user_id ,:message=>"该用户已经创建了关注货源."#, drop_dups: true
end
