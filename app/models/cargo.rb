# coding: utf-8
class  Cargo
  include Mongoid::Document
  include Mongoid::Timestamps
  include CitiesHelper
  # cattr_reader :per_page
  # @@per_page = 20      
  # cargo self info
  field :cargo_weight, :type=>String
  field :cargo_zuhuo, :type=>String
  field :cargo_bulk, :type=>String
  field :send_date, :type=>String
  field :comments, :type=>String
  field :status, :type=>String
  field :is_self,:type=>String

  #for not go back to find stock_cargo
  field :cate_name, :type=>String
  field :package_name, :type=>String
  field :big_category, :type=>String

  # important line info
  field :line, :type=>String
  field :fcity_name, :type=>String
  field :tcity_name, :type=>String
  field :fcity_code, :type=>String
  field :tcity_code, :type=>String   

  #important information
  field :zhuang_addr, :type=>String
  field :zhuang_time, :type=>String
  field :xie_addr, :type=>String
  field :contact, :type=>String
      
  field :price, :type=>String
  field :price_unit, :type=>String
      
  # from site
  field :from_site, :type=>String
  field :priority, :type=>Integer #show priority
      
  #tousu and jubao

      
  # statistic
  field :total_baojia, :type=>Integer
  field :total_xunjia, :type=>Integer
  field :total_match, :type=>Integer
  field :total_click, :type=>Integer
      
  field :cj_truck_id
  field :cj_quote_id
  field :cj_user_id
  field :cj_company_id
      

  field :user_id
  field :user_contact_id
  field :company_id
  field :stock_cargo_id
  
  #below is for phone concern, we need add this two field when we create cargo
  field :mobilephone, :type=>String
  field :fixphone, :type=>String

  index ([[:from_site,Mongo::ASCENDING],[:updated_at,Mongo::ASCENDING],[:status,Mongo::ASCENDING],[:fcity_code,Mongo::ASCENDING],[:tcity_code,Mongo::ASCENDING]])
  validates_presence_of :fcity_code,:tcity_code   #remove cate_name, could be empty from grasp
 
  before_create:check_unique
  after_save:expire,:notify
  def check_unique
    repeated=Cargo.where(:cate_name=>self.cate_name,:line=>self.line,:user_id=>self.user_id,:status=>"正在配车",
      :comments=>self.comments,:from_site=>self.from_site )
    unless repeated.size==0
      errors.add(:base,"不能重复发布货源信息")
      return false
    end
    return true
  end
  def expire
 
    ActionController::Base.new.expire_fragment("cargos_allcity_1")
    ActionController::Base.new.expire_fragment("cargos_allcity_1")
    ActionController::Base.new.expire_fragment("provincecargo")
    ActionController::Base.new.expire_fragment("users_center_#{self.user_id}")    
    city_level(self.fcity_code)[1].each do |city|
      ActionController::Base.new.expire_fragment("cargo_city_#{city}_")
      ActionController::Base.new.expire_fragment("cargo_city_#{city}_city")
    end
    city_level(self.tcity_code)[1].each do |city|
      ActionController::Base.new.expire_fragment("cargo_city_#{city}_")
      ActionController::Base.new.expire_fragment("cargo_city_#{city}_city")#this is for region code is same as city code issue
    end
  end
  
  def notify
    
    #find out email list of send city
    email_list= Array.new 
    sms_list= Array.new 
    concerncity=Concerncityc.where(:city=>self.fcity_code).first    
    email_list=email_list.concat(concerncity.emaillist)  unless concerncity.blank?

    #find out sms list of send city
    sms_list=sms_list.concat(concerncity.smslist) unless concerncity.blank?
    if not is_region?(self.fcity_code)  #is city then to notify the parent region subscribe also
      parentcity=Concerncityc.where(:city=>self.fcity_code.slice(0,4)+"00000000").first  
      unless parentcity.blank?
        email_list=email_list.concat(parentcity.emaillist)
        sms_list=sms_list.concat(parentcity.smslist)
      end
    end

 
    get_parent_line(self.line).each do |eachline|    #need consider parent line concern
      concernline=Concernlinec.where(:line=>eachline).first    
      email_list=email_list.concat(concernline.emaillist|| Array.new)  unless concernline.blank?
      sms_list=sms_list.concat(concernline.smslist || Array.new) unless concernline.blank?
    end

    concernuser=Concernuserc.where(:userid=>self.user_id).first    
    email_list=email_list.concat(concernuser.emaillist || Array.new ) unless concernuser.blank?
    sms_list=sms_list.concat(concernuser.smslist || Array.new ) unless concernuser.blank?
    

    concernphone1=Concernphonec.where(:mobilephone=>self.mobilephone).first    
    email_list=email_list.concat(concernphone1.emaillist || Array.new) unless concernphone1.blank?
    sms_list=sms_list.concat(concernphone1.smslist || Array.new) unless concernphone1.blank?
    concernphone2=Concernphonec.where(:fixphone=>self.fixphone).first 
    
    if concernphone2
      email_list=email_list.concat(concernphone2.emaillist )
      sms_list=sms_list.concat(concernphone2.smslist)
    end
    
    #update only do once 
    update_notify_list(email_list,sms_list)
  end
  
  def update_notify_list(email_list,sms_list)
  #  log=Logger.new("notify.log")
   # Emaillistc.destroy_all
    email_list.uniq!
    sms_list.uniq!
    email_list.each do |email|
      emailsubscribe=Emaillistc.where(:email=>email).first
      
      user=User.where(:email=>email).first
      
      unless user.id.to_s==self.user_id.to_s
        unless emailsubscribe.blank?
        #  new_cargolist=Array.new
          new_cargolist=emailsubscribe.cargolist||Array.new
        #  log.info "original cargo list=#{emailsubscribe.cargolist},size=#{new_cargolist.size}"
          new_cargolist<<self.id.to_s
        #   log.info "new cargo list=#{ new_cargolist},size=#{new_cargolist.size}"
          new_cargolist.uniq!
        #   log.info "uniq cargo list=#{ new_cargolist},size=#{new_cargolist.size}"
        #  emailsubscribe.update_attribute(:cargolist,nil) #why stupid operaton here
          emailsubscribe.update_attributes(:cargolist=>new_cargolist,:csize=>new_cargolist.size)
          
        else
           log.info "create emaillist for new user"
          emailsubscribe= Emaillistc.new
          emailsubscribe.email=email
          emailsubscribe.cargolist=[self.id.to_s]
          emailsubscribe.csize=1
          emailsubscribe.save
        end
  
      end
      #update each sms's cargo list
      sms_list.each do |sms|
        smssubscribe= Smslistc.where(:phone=>sms).first
        unless   smssubscribe.blank?
          Smslistc.where(:phone=>sms).first.push(:cargolist,self.id.to_s)
        else
          smssubscribe=Smslistc.new  
        end
      end
    end
  end
     
end
