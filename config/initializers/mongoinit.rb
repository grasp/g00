# To change this template, choose Tools | Templates
# and open the template in the editor.

#if not false, will always in production database 
if false
if ARGF.argv[0]=="development"
$debug=true
else
  $debug=false
end
 # $debug=true #remove this line !!!!
puts "$debug=#{$debug}"
#$debug=true
$mongo=Mongo::Connection.new('localhost', 27017)
$debug ? $db = $mongo.db('w090_development') : $db = $mongo.db('w090_production')
Mongoid.database = $db
end