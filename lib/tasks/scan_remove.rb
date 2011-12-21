# To change this template, choose Tools | Templates
# and open the template in the editor.
if false
require 'rubygems'
require 'mongo'
require 'logger'
require 'mongoid'

require '/opt/vob/g00/config/initializers/init/city_load.rb'
require '/opt/vob/g00/app/helpers/cities_helper.rb'
require '/opt/vob/g00/app/models/user.rb'
require '/opt/vob/g00/app/models/cargo.rb'
require '/opt/vob/g00/app/models/truck.rb'
require '/opt/vob/g00/app/models/expired_cargo.rb'
require '/opt/vob/g00/app/models/expired_truck.rb'
require '/opt/vob/g00/app/models/stock_cargo.rb'
require '/opt/vob/g00/app/models/stock_truck.rb'
require '/opt/vob/g00/app/models/ustatistic.rb'
require '/opt/vob/g00/app/models/quote.rb'
require '/opt/vob/g00/app/models/inquery.rb'
require '/opt/vob/g00/app/models/expired_quote.rb'
require '/opt/vob/g00/app/models/expired_inquery.rb'
require '/opt/vob/g00/app/models/scan.rb'
require '/opt/vob/g00/app/models/move.rb'

require '/opt/vob/g00/app/helpers/scans_helper.rb'
require '/opt/vob/g00/lib/tasks/mongoinit.rb'

include ScansHelper
scan_helper
move_helper
end
def scan_move
system("wget --spider http://w090.com/admin/scan") 
system("wget --spider http://w090.com/admin/move") 

system("wget --spider http://w090.com/admin/dev_expire") #to expire city navi bar
system("wget --spider http://w090.com/cargos/allcity") #to regenerate city navi  cache
system("wget --spider http://w090.com/trucks/allcity") #to regenerate city navi  cache
end