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
        :subject => "物流零距离网站-邀请您的第一次访问" )  do |format|
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
  
  def batch_insert_w090_mail
    netease_account=[]
    199.downto(1).each {|i|  netease_account<<"w090_"+ "%03d" % i+"@w090.com"}
    first_account=MailAccount.where(:fullname=>"w090_001@w090.com").first
    if first_account.blank? #insert mail account for first time
      netease_account.each do |account|
        new_account=Hash.new
        new_account[:address]="smtp.ym.163.com"
        new_account[:username]=account
        new_account[:fullname]=account
        new_account[:password]="w090w090#"
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
  
  def batch_insert_wl090_mail
    qq_account=[]
    199.downto(1).each {|i|  qq_account<<"w090_"+ "%03d" % i+"@wl090.com"}
    first_account=MailAccount.where(:fullname=>"w090_001@wl090.com").first
    if first_account.blank? #insert mail account for first time
      qq_account.each do |account|
        new_account=Hash.new
        new_account[:address]="smtp.exmail.qq.com"
        new_account[:username]=account
        new_account[:fullname]=account
        new_account[:password]="followme123#"
        new_account[:port]="587" #465
        new_account[:day_max]="49"
        new_account[:send_interval]="25"
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

    mail163_array=MailAccount.where(:address=>"smtp.ym.163.com").all
    qqmail_array=MailAccount.where(:address=>"smtp.exmail.qq..com").all
    mail_list=Array.new    
    0.upto(199).each do |i|
      small_list=Array.new
      small_list<<mail163_array[i]
      small_list<<qqmail_array[i]
      mail_list<<small_list
    end
    
    #for each mail account , sent out limited mail
    #  Rails.logger.info "mode=#{mode},domain=#{domain}"
    # if (Time.now.hour>22||Time.now.hour<7)
    #  mail_account[:day_max]=10  #first just limit the maxim numer of sent
    1.downto(1).each do |i|
      mail_list.each do |small_list|
        small_list.each do |mail_account|
          unless mail_account.nil?
            if mail_account.today_sent < mail_account[:day_max] && mail_account.status!="disabled"
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
                unless mail_account.nil?
                  company.email="w22812@mot.com"   if mode=="test"   
                  begin
                    unless mail_account.fail_counter.to_i>0
                       puts "#{mail_account.fullname} sent to #{company.email} start"
                      UserMailer.tuiguang_email(mail_account.fullname,company.email,company.name).deliver!          
                      company.update_attributes(:sent_counter=>1,:last_sent_time=>Time.now,:status=>"enabled")
                      mail_account.inc(:today_sent,1)
                      mail_account.inc(:total_sent,1) 
                    else
                      mail_account.update_attribute(:status,"disabled")
                      mail_account.status="disabled"
                    end
                  rescue
                    # Rails.logger.info " sent to #{company.email} failed"
                    @exception=$@
                    puts "#{mail_account.fullname} sent to #{company.email} failed"
                    puts    @exception
                    if ($@.to_s.match("authenticate") || $@.to_s.match("sysread_nonblock"))
                        mail_account.update_attribute(:status,"disabled")                      
                      sleep(10)
                    else
                     company.update_attributes(:sent_counter=>1,:last_sent_time=>Time.now,:status=>"disabled")
                    end
                    mail_account.inc(:fail_counter,1)                
                  end
                  puts "one group mail sent out"
                  sleep(5) #wait 5 second after each send out    
                else
                  sleep(10)
                end  
              end
            end
            sleep(35)  #after send out 3 mail, sleep 
          end
        end
        # else
        #   puts "not in correct time windows"
        #  end
      end
    end
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

