#coding:utf-8
#!/usr/local/bin/ruby
require 'rubygems'
require 'mechanize'
require 'mongo'
require 'logger'
require 'mongoid'
require 'action_mailer'
require 'pathname'
require 'forever'

pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent #do we have one line solution?

require File.join(project_root,"app","helpers","mail_accounts_helper.rb")
require File.join(project_root,"app","helpers","cities_helper.rb")
require File.join(project_root,"app","models","concerncityc.rb")
require File.join(project_root,"app","models","concernlinec.rb")
require File.join(project_root,"app","models","concernuserc.rb")
require File.join(project_root,"app","models","concernphonec.rb")
require File.join(project_root,"app","models","emaillistc.rb")
require File.join(project_root,"app","models","smslistc.rb")
require File.join(project_root,"app","helpers","cargos_helper.rb")

require File.join(project_root,"app","models","user.rb")
require File.join(project_root,"app","models","cargo.rb")
require File.join(project_root,"app","models","truck.rb")
require File.join(project_root,"app","models","grasp_record.rb")
require File.join(project_root,"app","models","room_contact.rb")


require File.join(project_root,"app","helpers","quzhougrasp_helper.rb")
require File.join(project_root,"app","helpers","tf56grasp_helper.rb")

require File.join(project_root,"app","models","lib_company.rb")

require File.join(project_root,"app","models","emaillistc.rb")
require File.join(project_root,"app","models","notifier.rb")

$project_root=project_root

require File.join(project_root,"config","initializers","init","cargo_big_category_load.rb")
require File.join(project_root,"config","initializers","init","cargo_option_load.rb")
require File.join(project_root,"config","initializers","init","truck_shape_load.rb")
require File.join(project_root,"config","initializers","init","truck_pinpai_load.rb")
require File.join(project_root,"config","initializers","init","truck_huicheng.rb")
require File.join(project_root,"lib","tasks","mongoinit.rb")

ActionMailer::Base.smtp_settings = {
  :user_name => "w090.mark",
  :password => "999317",
  :domain => "w090.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

ActionMailer::Base.delivery_method = :smtp
def notify
  puts "load lib done #{Time.now}"
  Emaillistc.where(:csize.gt =>0).asc(:updated_at).limit(1).each do |email|
    puts "find one email=#{email.email}"
    begin
      Notifier.send_notify_email(email,$project_root).deliver!
      email.update_attributes(:cargolist=>nil,:csize=>0)
    rescue
      puts $@
    end
  end
  puts "send finished #{Time.now}"
end


Forever.run do
  dir File.expand_path('../', __FILE__) # Default is ../../__FILE__

  #before :all do
  #  puts "All jobs will will wait me for 1 second"; sleep 1
  #end

  every 15.seconds do
   notify
  end
  
  on_error do |e|
    puts "Boom raised: #{e.message}"
  end

  on_exit do
    puts "Bye bye"
  end
end