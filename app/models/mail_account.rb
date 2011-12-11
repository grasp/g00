class MailAccount
  include Mongoid::Document
      include Mongoid::Timestamps
  field :address
  field :port, :type => String
   field :fullname, :type => String
  field :username, :type => String
  field :password, :type => String
  field :authentication, :type => String
  field :enable_startttls, :type => Boolean
  field :today_sent, :type => Integer
  field :total_sent, :type => Integer
  field :last_use
  field :rejected, :type => String
  field :status, :type => String

  field :day_max,:type=>Integer
  field :receiver_max,:type=>Integer
  field :send_interval,:type=>Integer
  field :fail_counter,:type=>Integer
end
