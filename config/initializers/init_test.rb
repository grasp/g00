#load test env in rails ,only for windows test

unless Object::RUBY_PLATFORM.match("linux")
  require 'mechanize'
  require  'rubygems'
  require 'active_support/all'
  require "test/unit"
end
