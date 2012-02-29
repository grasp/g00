class Plan
  include Mongoid::Document
  include Mongoid::Timestamps
  field :plansetting, :type => String
  field :user, :type => String
  field :system, :type => String
  field :branch, :type => String
  field :fa, :type => String
  field :title, :type => String
  field :tag , :type => String
  field :plan, :type => String
  field :procedure, :type => String
  field :summary, :type => String
  field :phase, :type => String
  field :deliver, :type => String
  field :comments, :type => String
  field :status, :type => String
  field :review, :type => String
  field :check, :type => Boolean
  field :plantype, :type => String
  field :priority,:type=>Integer
end
