# Load the rails application
require 'yaml'
YAML::ENGINE.yamler= 'syck'
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
