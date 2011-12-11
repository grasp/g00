#coding:utf-8
module MailAccountsHelper
  class UserMailer < ActionMailer::Base
    def test_email(account)
      mail(:to => "mark.xiansheng@gmail.com",
        :from => "#{account}@w090.com",
        :subject => "#{account} test",
        :body=>"This is test mail account work!")
    end
    
    def tuiguang_email(from,to,company_name)
      @company_name=company_name
      #to get latest cargo
      # to get latest truck
      @cargos=Cargo.limit(20).desc(:created_at)
      @trucks=Truck.limit(20).desc(:created_at)
      mail(:to => to,
        :from => from,
        :subject => "物流零距离-邀请你的访问" )  do |format|
        format.html { render '/admin/tuiguang' }
      end
    end
  end
  ActionMailer::Base.delivery_method = :smtp
  def batch_insert_gmail_account
    gmail_account=[]
    16.downto(1).each {|i|  gmail_account<<"w090."+ "%03d" % i}
    gmail_account.delete("w090.006")
    #gmail_account.delete("w090.001")
    first_account=MailAccount.where(:username=>"w090.001").first
    if first_account.blank? #insert mail account for first time
      gmail_account.each do |account|
        new_account=Hash.new
        new_account[:address]="smtp.gmail.com"
        new_account[:username]=account
        new_account[:fullname]=account+"@gmail.com"
        new_account[:password]="11102008"
        new_account[:port]="587"
        new_account[:day_max]="49"
        new_account[:send_interval]="15"
        new_account[:authentication]="plain"
        new_account[:enable_startttls]="true"
        a=MailAccount.new(new_account)
        raise unless a.save
      end
    end
  end
  def batch_insert_netease_account
    netease_account=[]
    15.downto(1).each {|i|  netease_account<<"w090_"+ "%03d" % i}
    #have a mistake for w011
    netease_account.delete("w090_011")
    netease_account<<"w90_011"
    first_account=MailAccount.where(:fullname=>"w090_001@163.com").first
    if first_account.blank? #insert mail account for first time
      netease_account.each do |account|
        new_account=Hash.new
        new_account[:address]="smtp.163.com"
        new_account[:username]=account
        new_account[:fullname]=account+"@163.com"
        new_account[:password]="followme123#"
        new_account[:port]="25"
        new_account[:day_max]="49"
        new_account[:send_interval]="25"
        new_account[:authentication]=":login"
        new_account[:enable_startttls]="true"
        a=MailAccount.new(new_account)
        raise unless a.save
      end
    end
  end
  def batch_insert_hotmail_account
    hotmail_account=[]
    8.downto(1).each {|i|  hotmail_account<<"w090_"+ "%03d" % i}
    #have a mistake for w011
    #  hotmail_account.delete("w090_011")
    #   hotmail_account<<"w90_011"
    first_account=MailAccount.where(:fullname=>"w090_001@hotmail.com").first
    if first_account.blank? #insert mail account for first time
      hotmail_account.each do |account|
        new_account=Hash.new
        new_account[:address]="smtp.live.com"
        new_account[:username]=account
        new_account[:fullname]=account+"@hotmail.com"
        new_account[:password]="followme123#"
        new_account[:port]="25"
        new_account[:day_max]="49"
        new_account[:send_interval]="15"
        new_account[:authentication]=":login"
        new_account[:enable_startttls]="true"
        a=MailAccount.new(new_account)
        raise unless a.save
      end
    end
  end

  def sent_tuiguang_email(mode)
    
    #clean all today_sent counter to 0
    MailAccount.all.each do |mail_account|
      mail_account.update_attribute(:today_sent,0)
      mail_account.update_attribute(:fail_counter,0)
    end
 
    #get a send list of each domain
    gmail_array=MailAccount.where(:address=>"smtp.gmail.com").all
    mail163_array=MailAccount.where(:address=>"smtp.163.com").all
    hotmail_array=MailAccount.where(:address=>"smtp.live.com").all
    mail_list=Array.new
    
    0.upto(14).each do |i|
      small_list=Array.new
      small_list<<gmail_array[i]
      small_list<<mail163_array[i]
      small_list<< hotmail_array[i]
      mail_list<<small_list
    end
    
    #for each mail account , sent out limited mail
    #  Rails.logger.info "mode=#{mode},domain=#{domain}"
    # if (Time.now.hour>22||Time.now.hour<7)
    #  mail_account[:day_max]=10  #first just limit the maxim numer of sent
   15.downto(0).each do |i|
      mail_list.each do |small_list|  
        small_list.each do |mail_account|        
         
          unless mail_account.nil?
            if mail_account.today_sent < mail_account[:day_max] && mail_account.status!="disabled"
              if mail_account.address=="smtp.gmail.com"
                ActionMailer::Base.smtp_settings = {
                  :enable_starttls_auto => mail_account.enable_startttls,
                  :address => mail_account.address,
                  :port => mail_account.port,
                  :authentication => mail_account.authentication ,
                  :user_name => mail_account.username,
                  :password => mail_account.password
                }
              end
              if mail_account.address=="smtp.163.com"
                ActionMailer::Base.smtp_settings = {
                  :address => mail_account.address,
                  :port => mail_account.port,
                  :domain   => "163.com",
                  :authentication => :login ,
                  :user_name => mail_account.fullname,
                  :password => mail_account.password
                }
              end
              if mail_account.address=="smtp.live.com"
                ActionMailer::Base.smtp_settings = {
                  :address => mail_account.address,
                  :port => mail_account.port,
                  #    :domain   => "hotmail.com",
                  :authentication => :login ,
                  :user_name => mail_account.fullname,
                  :password => mail_account.password
                }
              end
              if mode=="test"
                ActionMailer::Base.smtp_settings = {
                  :address => 'smtp.mot.com',
                  :port => 25
                }
              end
              #find #{mail_account[:day_max]} lib_company and send out email for each company
              mail_account.fullname="hunter.hu@nsn.com" if mode=="test"
              mail_account[:day_max]=1  if mode=="test"

              LibCompany.where(:sent_counter=>nil,:status.ne=>"disabled").limit(1).each do |company|
                #for debug purpose
                #  company.email="mark.xiansheng@gmail.com"   if mode=="test"  && domain=="smtp.gmail.com"
                #  company.email="w090_001@163.com"   if mode=="test" && domain=="smtp.163.com"
                #  company.email="w090_001@hotmail.com"   if mode=="test" && domain=="smtp.live.com"
                company.email="w22812@mot.com"   if mode=="test"
                #Rails.logger.info " to #{company.email} from #{mail_account.fullname}"
        
                begin
                  UserMailer.tuiguang_email(mail_account.fullname,company.email,company.name).deliver!          
                  company.update_attributes(:sent_counter=>1,:last_sent_time=>Time.now,:status=>"enabled")
                  mail_account.inc(:today_sent,1)
                  mail_account.inc(:total_sent,1)          
                rescue
                  # Rails.logger.info " sent to #{company.email} failed"
                  @exception=$@
                  puts "#{mail_account.fullname} sent to #{company.email} failed"
                  puts    @exception
                  unless ($@.to_s.match("authenticate"))
                  company.update_attributes(:sent_counter=>1,:last_sent_time=>Time.now,:status=>"disabled")
                  else
                    mail_account.update_attribute(:status,"disabled")
                  end
                  mail_account.inc(:fail_counter,1)                
                end
               # puts "one mail #{company.email} sent out!"
              end
            end   
          end           
        end
       # puts "3 mail sent out!"
        sleep(30)  #after send out 3 mail, sleep 20 seconds
      end
    end
    # else
    #   puts "not in correct time windows"
    #  end
  end

  def   receive_helper(mode,domain)

    Rails.logger.info "start to receive mode=#{mode},domain=#{domain}"

    MailAccount.where(:address=>domain).each do |mail_account|
      if domain=="smtp.gmail.com"
        ActionMailer::Base.smtp_settings = {
          :enable_starttls_auto => mail_account.enable_startttls,
          :address => mail_account.address,
          :port => mail_account.port,
          :authentication => mail_account.authentication ,
          :user_name => mail_account.username,
          :password => mail_account.password
        }
      end
      if domain=="smtp.163.com"
        ActionMailer::Base.smtp_settings = {
          :address => mail_account.address,
          :port => mail_account.port,
          :domain   => "163.com",
          :authentication => :login ,
          :user_name => mail_account.fullname,
          :password => mail_account.password
        }
      end
      if domain=="smtp.live.com"
        ActionMailer::Base.smtp_settings = {
          :address => mail_account.address,
          :port => mail_account.port,
          #    :domain   => "hotmail.com",
          :authentication => :login ,
          :user_name => mail_account.fullname,
          :password => mail_account.password
        }
      end
      #receive mail here      


    end

  end
end
