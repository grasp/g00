# To change this template, choose Tools | Templates
# and open the template in the editor.
if false
require 'rubygems'
require 'mechanize'
require 'mongo'
require 'logger'
require 'mongoid'
require 'action_mailer'
require '/opt/vob/g00/app/models/mail_account.rb'
require '/opt/vob/g00/app/models/cargo.rb'
require '/opt/vob/g00/app/models/truck.rb'
require '/opt/vob/g00/app/models/lib_company.rb'
require '/opt/vob/g00/app/helpers/mail_accounts_helper.rb'
require '/opt/vob/g00/config/initializers/init/cargo_big_category_load.rb'
require '/opt/vob/g00/config/initializers/init/cargo_option_load.rb'
require '/opt/vob/g00/config/initializers/init/truck_shape_load.rb'
require '/opt/vob/g00/config/initializers/init/truck_pinpai_load.rb'
require '/opt/vob/g00/config/initializers/init/truck_huicheng.rb'
require '/opt/vob/g00/lib/tasks/mongoinit.rb'

include MailAccountsHelper

puts "sart to fix lib company issue"
counter=0
      LibCompany.where(:sent_counter=>1,:status.ne=>"disabled",:last_sent_time.gte=>"2011-08-26 00:00:00 +0800").each do |company|
        company.update_attributes(sent_counter: nil,last_sent_time: nil)
        counter+=1
      end
puts "send finished,total counter=#{counter}"

end