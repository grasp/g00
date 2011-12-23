#coding:utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'pathname'
pn = Pathname.new(File.dirname(__FILE__))
sms_path=pn.parent #do we have one line solution?
exec(File.join(sms_path,"sms","sms.bat")+" "+ARGF.argv[0]+" "+ARGF.argv[1])


