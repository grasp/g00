#coding:gb2312
require 'rubygems'  
require 'Win32Api'  

smsmode=Win32API.new("MonDem.dll","fnSetThreadMode",'L','L')  
puts "fnSetThreadMode return ="+smsmode.call(1).to_s

modemtype=Win32API.new("MonDem.dll","fnSetModemType",['L','L'],'L') 
0.upto(7).each do |i|
puts "setmodemtype="+modemtype.call(i,0).to_s
end

puts "max support port="+Win32API.new("MonDem.dll","fnGetPortMax","" ,'L').call().to_s 
initmodem=Win32API.new("MonDem.dll","fnInitModem",'L','L') 
 puts "init return="+initmodem.call(-1).to_s
 
  
getstatus=Win32API.new("MonDem.dll","fnGetStatus",'L','L') 
  0.upto(7).each do |i|
  puts "port #{i} status before send="+getstatus.call(i).to_s
  end 
  
sendsms=Win32API.new("MonDem.dll","fnSendMsg",['L','P','P'],'L') 

puts "sendsms="+sendsms.call(-1,"15967126712","恭喜发财！").to_s # we need wait up until send done
while true
readmsgx=Win32API.new("MonDem.dll","fnReadMsgEx",['L','P','P'],'L')
header=String.new
msgbox=String.new
if readmsgx.call(2,header,msgbox)==0
  puts "sent done"
#puts  header
# msgbox
break;
end
puts "sleep 5 second to wait send finish"
sleep 5
end


0.upto(7).each do |i|

puts "fnGetSndCount#{i}="+Win32API.new("MonDem.dll","fnGetSndCount","I",'L').call(i).to_s 
 end

getstatus=Win32API.new("MonDem.dll","fnGetStatus",'L','L') 
  0.upto(7).each do |i|
  puts "port #{i} status after send ="+getstatus.call(i).to_s
  end
  
  getsendcount=Win32API.new("MonDem.dll","fnGetSndCount",'L','L') 
  0.upto(7).each do |i|
  puts "sendcount #{i} status="+getsendcount.call(i).to_s
  end
  
clostmodem=Win32API.new("MonDem.dll","fnCloseModem",'L','L') 
  0.upto(7).each do |i|
  puts "port #{i}close status="+clostmodem.call(i).to_s
  end