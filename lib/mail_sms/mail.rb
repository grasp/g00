# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'rubygems'
require 'mechanize'
require 'mongo'
require 'logger'
require 'mongoid'
require 'action_mailer'
require 'pathname'

pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?

require File.join(project_root,"app","helpers","mail_accounts_helper.rb")
require File.join(project_root,"app","helpers","cities_helper.rb")

require File.join(project_root,"app","models","mail_account.rb")
require File.join(project_root,"app","models","user.rb")
require File.join(project_root,"app","models","stock_cargo.rb")
require File.join(project_root,"app","models","cargo.rb")
require File.join(project_root,"app","models","jubao.rb")
require File.join(project_root,"app","helpers","cargos_helper.rb")

require File.join(project_root,"app","models","truck.rb")
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
puts "load lib done"
Emaillistc.where(:csize.gt =>0).asc(:updated_at).limit(1).each do |email|
  puts "find one email=#{email.email}"
  begin
  Notifier.send_notify_email(email).deliver!
  email.update_attributes(:cargolist=>nil,:csize=>0)
  rescue
    puts $@
  end
end

puts "send finished"

