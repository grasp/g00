#!/bin/bash


cd /home/hunter
rm -rf dump
mongodump
cd dump
mongorestore --drop --db w090_development ./w090_production
