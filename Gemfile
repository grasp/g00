require 'rubygems'


source 'http://ruby.taobao.org'

gem 'rails', '3.2.1'
gem "railties", '~>3.2.1'
gem "builder","3.0.0"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   "~> 3.2.3"
  gem 'coffee-rails' , "~> 3.2.1"
  gem 'uglifier', "~> 1.0.3"
end


#gem "mechanize" not used for now
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'will_paginate',:git => 'http://github.com/mislav/will_paginate.git',:branch=>'rails3'
gem "will_paginate", "~> 3.0.pre4"
#gem "will_paginate_mongoid"
#gem 'kaminari'

gem 'redis', '2.2.1'
gem 'bson' , "~>1.5.2"
gem 'redis-store', '1.0.0.rc1'


gem 'mongo', '1.5.2'
gem "mongoid", "~>2.3.0"
#gem 'memcache-client'
#gem 'unicorn'
gem "webrobots", "~> 0.0.10", :git => 'http://github.com/knu/webrobots.git'
#gem "webrobots","0.0.11"

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

#group :development do
 # gem "rails-dev-boost", :git => "http://github.com/thedarkone/rails-dev-boost.git", :require => "rails_development_boost"
 #gem 'rails-dev-boost', :require => 'rails_development_boost'
#end

#group :test do
 # gem "rails-dev-boost", :git => "http://github.com/thedarkone/rails-dev-boost.git", :require => "rails_development_boost"
#end

gem "geocoder"
gem "gmaps4rails"
gem 'mongoid_spacial',"~>0.2.16"


