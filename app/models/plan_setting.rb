class PlanSetting
  include Mongoid::Document
  include Mongoid::Timestamps
  field:topic, :type => String
  field :tag, :type => String
  field :fa, :type => String
  field :system, :type => String
  field :branch, :type => String
  field :creater, :type => String
  field :contributor, :type => Array
  field :status, :type => String
  field :fapriority, :type => Integer
end
