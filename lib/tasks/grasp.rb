# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'rubygems'
require 'pathname'
require 'mechanize'
require 'mongo'
require 'logger'
require 'mongoid'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?
require File.join(project_root,"app","helpers","cities_helper.rb")
require File.join(project_root,"app","helpers","quzhougrasp_helper.rb")
require File.join(project_root,"app","helpers","tf56grasp_helper.rb")


require File.join(project_root,"app","models","user.rb")
require File.join(project_root,"app","models","cargo.rb")
require File.join(project_root,"app","models","truck.rb")
require File.join(project_root,"app","models","grasp_record.rb")
require File.join(project_root,"app","models","room_contact.rb")



require File.join(project_root,"config","initializers","init","city_dic.rb")
require File.join(project_root,"config","initializers","init","city_load.rb")
require File.join(project_root,"lib","tasks","mongoinit.rb")
require File.join(project_root,"lib","tasks","56qq.rb")

require File.join(project_root,"lib","tasks","56qq_helper.rb")

require File.join(project_root,"lib","tasks","56135.rb")
include QuzhougraspHelper
include Tf56graspHelper

begin
get_quzhou_grasps
rescue
    puts $@
end
get_tf56_grasps
begin
parse_56qq
rescue
  puts $@
end

begin
parse_56135
rescue
  puts $@
end
system("wget --spider http://w090.com/admin/dev_expire") #to expire city navi bar
system("wget --spider http://w090.com/cargos/allcity") #to regenerate city navi  cache
system("wget --spider http://w090.com/trucks/allcity") #to regenerate city navi  cache




