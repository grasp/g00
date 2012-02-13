 # coding: utf-8
class User 
  include Mongoid::Document
  include Mongoid::Timestamps
 # include UsersHelper  
  attr_accessor:password_confirmation,:email_confirm  
  field :email,:type=>String
  field :name,:type=>String
  field :admin,:type=>Boolean, :default=>false
  field :real_name,:type=>String
  field :hashed_password,:type=>String
  field :salt,:type=>String
  field :status,:type=>String
  field :activate,:type=>String
  field :preference,:type=>Integer
  field :mobilephone,:type=>String
  field :last_login
  field :inviten,:type=>Integer

  field  :user_contact_id
  field  :ustatistic_id
  field  :company_id
  #field  :stock_cargo_ids
  #field  :cargo_ids
  # field  :stock_truck_ids
  # field  :truck_ids
  #field :inquery_ids
  # field :quote_ids
  
  validates_presence_of :email,:name,:message=>"用户名和email必须填写."
  validates_presence_of :mobilephone,:message=>"手机必须填写."
  validates_uniqueness_of :name ,:message=>"该用户名已经存在."
  validates_uniqueness_of :email ,:message=>"该email已经存在."
  validates_uniqueness_of :mobilephone ,:message=>"该手机已经存在."
  
   def self.authenticated_with_token(user_id, stored_salt)
    begin
     u = self.find(user_id)
     u && u.salt == stored_salt ? u : nil
     return u
    rescue
      Rails.logger.info("authentication failure!!")
       return nil
    end
   end
  
  def self.authenticate(email_or_name,password)
    if(email_or_name.match(/.*@.*\..*/))
     user=self.first(:conditions => { :email=>email_or_name.to_s })     
    else
      user=self.first(:conditions => { :name=>email_or_name.to_s })
    end

    if user
      expected_password=encrypted_password(password,user.salt)
      if user.hashed_password!=expected_password
        user= nil
        message="密码不对"
      end
    else
    message="#{email_or_name}用户不存在"
    user=nil
    end
    
    [user,message]
  end

  def password
    @password
  end  
  
  #here will generate password ,each result is different even have same password
  def password=(pwd)
    @password=pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password=User.encrypted_password(self.password, self.salt)
  end

 #private

  def password_non_blank
    errors.add_to_base("Missing password")  if :hashed_password.blank?
  end

 def self.encrypted_password(password,salt)
    string_to_hash=password+ "wibble" +salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt= self.object_id.to_s+rand.to_s
  end
  

end
