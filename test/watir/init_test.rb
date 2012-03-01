
require 'pathname'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?

require File.join(project_root,"test","watir","w090_test_common.rb")

#include all helper, we could resuse some operation
require File.join(project_root,"test","watir","users","users_helper.rb")
require File.join(project_root,"test","watir","companies","companies_helper.rb")
require File.join(project_root,"test","watir","cargos","cargos_helper.rb")
require File.join(project_root,"test","watir","trucks","trucks_helper.rb")