#coding:utf-8
require 'rubygems'
require 'pathname'
require 'mechanize'
require 'mongo'
require 'logger'
require 'mongoid'
require "sqlite3"

ARGF.argv[0]=="development" ? $debug=true : $debug=false
$mongo=Mongo::Connection.new('localhost', 27017)
$debug ? $db = $mongo.db('w090_development') : $db = $mongo.db('w090_production')
Mongoid.database = $db

pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?

require File.join(project_root,"lib","tasks","mongoinit.rb")
require File.join(project_root,"config","initializers","init","city_dic.rb")
require File.join(project_root,"config","initializers","init","city_load.rb")
require File.join(project_root,"lib","tasks","load_cookie.rb")
require File.join(project_root,"app","helpers","cities_helper.rb")
require File.join(project_root,"app","helpers","cargos_helper.rb")
require File.join(project_root,"app","helpers","trucks_helper.rb")



require File.join(project_root,"app","models","concernlinec.rb")
require File.join(project_root,"app","models","concernuserc.rb")
require File.join(project_root,"app","models","concernphonec.rb")
require File.join(project_root,"app","models","emaillistc.rb")
require File.join(project_root,"app","models","smslistc.rb")

require File.join(project_root,"app","models","user.rb")
require File.join(project_root,"app","models","ustatistic.rb")
require File.join(project_root,"app","models","cargo.rb")
require File.join(project_root,"app","models","truck.rb")
require File.join(project_root,"app","models","grasp_record.rb")
require File.join(project_root,"app","models","room_contact.rb")
require File.join(project_root,"app","models","concerncityc.rb")
require File.join(project_root,"app","models","sitedatum.rb")

require File.join(project_root,"app","helpers","quzhougrasp_helper.rb")
require File.join(project_root,"app","helpers","tf56grasp_helper.rb")
require File.join(project_root,"lib","tasks","56qq_helper.rb")
require File.join(project_root,"lib","tasks","56qq.rb")
require File.join(project_root,"lib","tasks","56qq_helper.rb")
require File.join(project_root,"lib","tasks","56135.rb")
require File.join(project_root,"lib","tasks","haoyun56.rb")
require File.join(project_root,"lib","tasks","scan_remove.rb")



include QuzhougraspHelper
include Tf56graspHelper