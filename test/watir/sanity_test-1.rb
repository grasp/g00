# To change this template, choose Tools | Templates
# and open the template in the editor.

#coding:utf-8

require 'pathname'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?
require File.join(project_root,"test","watir","init_test.rb")
require File.join(project_root,"test","watir","users","user_test.rb")
require File.join(project_root,"test","watir","companies","company_test.rb")
require File.join(project_root,"test","watir","cargos","cargo_test.rb")
require File.join(project_root,"test","watir","trucks","truck_test.rb")