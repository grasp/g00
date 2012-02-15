# Load the rails application
require 'yaml'
require 'rack/cache'
YAML::ENGINE.yamler= 'syck'
#Since version 3.0.0, the Array class extension with pagination isn't included in the core_ext.rb file:
require 'will_paginate/array' #https://github.com/mislav/will_paginate/issues/163

require File.expand_path('../application', __FILE__)
# Initialize the rails application
G0::Application.initialize!


ActionMailer::Base.smtp_settings = {
  :user_name => "w090.mark",
  :password => "999317",
  :domain => "w090.com",
  :address => "smtp.sendgrid.net",
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
