#!/bin/bash


cd /opt/vob
date=`date +"%G_%m_%d_%k_%M_%S"`

#first get git for clone
if [ -d "/opt/vob/tmp2/g00" ];then
#git checkout bootstrap
if [ $? -ne 0 ];then
  print "checkout tmp g00 to bootstrap fail"
  return 1
 fi

else
cd /opt/vob/tmp2
git clone http://grasp:improvew090#@github.com/grasp/g00.git
if [  $? -ne 0 ];then
  print "clone g00 to tmp fail"
  return 1
 fi

cd /opt/vob/tmp2/g00
#git checkout bootstrap
if [ $? -ne 0 ];then
  print "checkout tmp g00 to bootstrap fail"
  return 1
 fi


fi

cd /opt/vob/g00
thin stop -s 3
if [ $? -ne 0 ];then
  print "stop original thin fail"
  return 1
 fi


cd /opt/vob
mv g00 "$date"

if [ $? -ne 0 ];then
  print "backup original g00 fail"
  return 1
 fi

cd /opt/vob
mv tmp2/g00 g00
if [ $? -ne 0 ];then
  print "mv tmp g00 fail"
  return 1
 fi

cd g00
thin start -d -e production -s 3

if [  $? -ne 0 ];then
  print "last step to start rails fail"
  return 1
 fi

