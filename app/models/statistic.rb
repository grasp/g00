 # coding: utf-8
class Statistic
   include Mongoid::Document
   include Mongoid::Timestamps

     field :total_ip, :type=>Integer
     field :total_spider, :type=>String
     field :total_page,:type=>Integer

end
