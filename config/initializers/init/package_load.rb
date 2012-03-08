# coding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'iconv'

$KCODE="U"
$package_category_one=Hash.new
$package_category_two=Hash.new
$packagetree=Hash.new

def load_package_category_to_hash
  filename=File.dirname(__FILE__)+File::SEPARATOR+"package_category.txt"
  open(filename).each do |line|
    line=line.force_encoding("utf-8")
    if not line.nil?
    #  puts "line=#{line}"
      code= line.match(/^\d\w+/)
      if not code.nil?
        code=code.to_s
        code.chomp!
        code.strip!
        #puts "code=#{code}"
        #notes , the last line need a enter
        name=line.match(/\W+/)
        name=name.to_s
        name.chomp!
        name.strip!

     if code.match(/\d000/)  # if first level
       $package_category_one[code]=name  #to find name for first level
       $packagetree[code]={}
     else
       parent_code=code[0]+"000"
       $packagetree[parent_code][code]=name
     end  
     
        $package_category_two[code]=name
      end
    end
  end
end
load_package_category_to_hash
$packagetree.freeze
$package_category_one.freeze





