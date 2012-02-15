# To change this template, choose Tools | Templates
# and open the template in the editor.

#coding:utf-8

require 'pathname'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?
require File.join(project_root,"test","watir","w090_test_common.rb")
require File.join(project_root,"test","watir","users","users_helper.rb")
require File.join(project_root,"test","watir","companies","companies_helper.rb")
require File.join(project_root,"test","watir","cargos","cargos_helper.rb")

require File.join(project_root,"test","watir","users","user_login_logout.rb")
require File.join(project_root,"test","watir","companies","company_test.rb")
require File.join(project_root,"test","watir","cargos","cargos_test.rb")