#!/usr/bin/ruby
require 'pathname'
require 'forever'
pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?
require File.join(project_root,"lib","tasks","grasp_init.rb")


    scan_move


 
