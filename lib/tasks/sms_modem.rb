#coding:utf-8
require 'rubygems'  
require 'Win32Api'  

#SetThreadMode=Win32API.new(File.dirname(__FILE__)+"\\MonDem.dll","SetThreadMode","i","i")  
#smsmode=Win32API.new("MonDem.dll","fnSetThreadMode","l","l")  
#puts "fnSetThreadMode return ="+smsmode.call(1).to_s

modemtype=Win32API.new("MonDem.dll","fnSetModemType",["l","l"],"l") 
0.upto(7).each do |i|
puts "setmodemtype="+modemtype.call(i,0).to_s
end

initmodem=Win32API.new("MonDem.dll","fnInitModem","l","l") 
 puts "init return="+initmodem.call(-1).to_s
 
getstatus=Win32API.new("MonDem.dll","fnGetStatus","l","l") 
  0.upto(7).each do |i|
  puts "port #{i} status before send="+getstatus.call(i).to_s
  end 
  
sendsms=Win32API.new("MonDem.dll","fnSendMsg",["l","p","p"],"l") 
0.upto(7).each do |i|
puts "sendsms="+sendsms.call(i,"13788907003","短信猫测试信息，恭喜发财!").to_s
end

readmsgx=Win32API.new("MonDem.dll","fnReadMsgEx",["l","p","p"],"l")
0.upto(7).each do |i|
header=String.new
msgbox=String.new
puts "readmsgx="+readmsgx.call(i,header,msgbox).to_s
puts  header
puts msgbox
end

getstatus=Win32API.new("MonDem.dll","fnGetStatus","l","l") 
  0.upto(7).each do |i|
  puts "port #{i} status after send ="+getstatus.call(i).to_s
  end
  
  getsendcount=Win32API.new("MonDem.dll","fnGetSndCount","l","l") 
  0.upto(7).each do |i|
  puts "sendcount #{i} status="+getsendcount.call(i).to_s
  end
  
clostmodem=Win32API.new("MonDem.dll","fnCloseModem","l","l") 
  0.upto(7).each do |i|
  puts "port #{i}close status="+clostmodem.call(i).to_s
  end