#!/bin/bash


cd /opt/vob
cd /opt/vob/tmp 
if [ -a "g00" ];then
cd /opt/vob/tmp/g00
thin stop
 if [  ! $? -eq 0 ];then
 print "stop thin fail"
  return 1
 fi
fi

cd /opt/vob/tmp
rm -rf *
git clone http://grasp:improvew090#@github.com/grasp/g00.git

if [  ! $? -eq 0 ];then
 print "clone g00 fail"
  return 1
 fi

cd g00
#git checkout bootstrap

 if [  ! $? -eq 0 ];then
  print "checkout bootstrap fail"
  return 1
 fi


thin start -d -e development -p 4500

 if [  ! $? -eq 0 ];then
  print "start thin fail"
  return 1
 fi

