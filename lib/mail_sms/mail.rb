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
require File.join(pn,"app","models","mail_account.rb")
require File.join(pn,"app","models","cargo.rb")
require File.join(pn,"app","models","truck.rb")
require File.join(pn,"app","models","lib_company.rb")

require File.join(pn,"app","models","emaillistc.rb")
require File.join(pn,"app","models","notify.rb")

require File.join(pn,"app","helpers","mail_accounts_helper.rb")
require File.join(pn,"config","initializers","init","cargo_big_category_load.rb")
require File.join(pn,"config","initializers","init","cargo_option_load.rb")
require File.join(pn,"config","initializers","init","truck_shape_load.rb")
require File.join(pn,"config","initializers","init","truck_pinpai_load.rb")
require File.join(pn,"config","initializers","init","truck_huicheng.rb")
require File.join(pn,"lib","tasks","mongoinit.rb")

puts "load lib done"
Emaillistc.where(:cargolist.size => 0).asc(:updated_at).limit(1).each do |email|
  Notify.sent_notify_email(email).deliver!
end
puts "send finished"

