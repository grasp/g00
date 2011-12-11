class LibCompany
  include Mongoid::Document
  
  field :name, :type => String
  field :email, :type => String
  field :mobile, :type => String
  field :phone, :type => String
  field :contact, :type => String
  field :fax, :type => String
  field :msn, :type => String
  field :qq, :type => String
  field :intro, :type => String
  field :city, :type => String
  field :addr, :type => String
  field :from_site, :type => String
  #for mail sent statistic
  field :last_sent_time,:type=>String
  field :sent_counter,:type=>Integer
  field :status,:type=>String

end
class LibCompanyTest
  include Mongoid::Document
  field :name, :type => String
  field :email, :type => String
  field :mobile, :type => String
  field :phone, :type => String
  field :contact, :type => String
  field :fax, :type => String
  field :msn, :type => String
  field :qq, :type => String
  field :intro, :type => String
  field :city, :type => String
  field :addr, :type => String
  field :from_site, :type => String
end

