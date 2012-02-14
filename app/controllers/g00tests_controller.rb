
#seemed not work 
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?
  require File.join(project_root,"test","mechanize","user_test.rb")

# coding: utf-8
class G00testsController < ApplicationController

  before_filter:admin_authorize
  layout "g00test"  
def g00test
 
end

end
