require 'rubygems'
require 'mongo'

source 'http://ruby.taobao.org'

gem 'rails', '3.0.7'
gem "mechanize"
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'will_paginate',:git => 'http://github.com/mislav/will_paginate.git',:branch=>'rails3'
gem "will_paginate", "~> 3.0.pre2"

gem 'redis', '2.2.1'
gem 'redis-store', '1.0.0.rc1'

#gem 'unicorn'
gem "mongoid", "2.2.2"
#gem 'memcache-client'
gem "webrobots", "~> 0.0.10", :git => 'http://github.com/knu/webrobots.git'
#gem "webrobots","0.0.11"
gem 'bson' , "1.5.2"
platform=Object::RUBY_PLATFORM
unless  platform.match("linux").nil?#for linux
gem 'thin'
gem 'firewatir'
gem "bson_ext", "~> 1.2"
gem 'eventmachine', "0.12.10"
else
  gem 'watir'
end

#dameon and every task
gem 'foreverb'

gem 'request-log-analyzer'
#gem 'dalli'
# Use unicorn as the web server
# Deploy with Capistrano
# gem 'capistrano'
# To use debugger
# gem 'ruby-debug'
# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'
# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
group :development do
  gem "rails-dev-boost", :git => "http://github.com/thedarkone/rails-dev-boost.git", :require => "rails_development_boost"
 #gem 'rails-dev-boost', :require => 'rails_development_boost'
end

group :test do
  gem "rails-dev-boost", :git => "http://github.com/thedarkone/rails-dev-boost.git", :require => "rails_development_boost"
end
#test
