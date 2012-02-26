require 'rubygems'


source 'http://ruby.taobao.org'

gem 'rails', '3.2.1'
gem "railties", '~>3.2.1'
gem "builder","3.0.0"
gem "ffi","1.0.9"
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   "3.2.3"
  gem 'coffee-rails' , "~> 3.2.1"
  gem 'uglifier', "1.0.4"
end
gem 'closure-compiler'

gem "mechanize" 
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'will_paginate',:git => 'http://github.com/mislav/will_paginate.git',:branch=>'rails3'
gem "will_paginate", "~> 3.0.pre4"
#gem "will_paginate_mongoid"
#gem 'kaminari'

gem 'redis', '2.2.1'
gem 'bson' , "~>1.5.2"
gem 'redis-store', "~>1.0.0.rc1"

gem 'mongo', '1.5.2'
gem "mongoid", "~>2.4.5"
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

gem "geocoder"
gem "gmaps4rails"
gem 'mongoid_spacial',"~>0.2.16"
#gem 'tinymce-rails'
#gem "ckeditor", "3.7.0.rc3"
#gem 'mongoid-paperclip', :require => 'mongoid_paperclip'
#gem "carrierwave-mongoid", :require => 'carrierwave/mongoid'
#gem "mini_magick"
gem "carrierwave"
gem "rails_kindeditor"
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'


