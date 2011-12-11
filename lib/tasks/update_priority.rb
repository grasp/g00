# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'pathname'
require 'mongoid'

pn = Pathname.new(File.dirname(__FILE__))
project_root=pn.parent.parent #do we have one line solution?
require File.join(project_root,"app","models","cargo.rb")
require File.join(project_root,"app","models","truck.rb")
require File.join(File.dirname(__FILE__),"mongoinit.rb")
Cargo.where(:from_site=>"local").each do |cargo|
  cargo.update_attribute(:priority,100)
end
Cargo.where(:from_site=>"quzhou").each do |cargo|
  cargo.update_attribute(:priority,300)
end
Cargo.where(:from_site=>"tf56").each do |cargo|
  cargo.update_attribute(:priority,300)
end

Truck.where(:from_site=>"local").each do |cargo|
  cargo.update_attribute(:priority,100)
end
Truck.where(:from_site=>"quzhou").each do |cargo|
  cargo.update_attribute(:priority,300)
end
Truck.where(:from_site=>"tf56").each do |cargo|
  cargo.update_attribute(:priority,300)
end

