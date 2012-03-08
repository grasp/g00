# coding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'iconv'

$KCODE="U"
   
  $cargo_category_one=Hash.new
  $cargo_category_two=Hash.new
#  $cargo_category_three=Hash.new
  $catename=Hash.new
  $catetree=Hash.new

def load_cargo_category_to_hash
  filename=File.dirname(__FILE__)+File::SEPARATOR+"cargo_category.txt"
  open(filename).each do |line|
  line=line.force_encoding("utf-8")
# line=line.chomp!
#  line=Iconv.conv("utf-8","GBK",line)
  code= line.match(/\d+/)
  code=code.to_s
  #notes , the last line need a enter
  name=line.match(/\s.*\n/)
  name=name.to_s.chomp!
  unless code.nil?
 # $cargo_category.store(code,name) 
 if (code.match(/\d\d0000/))
   $cargo_category_one[code]=name
   $catename[code]=name
   $catetree[code]={}
   
 elsif(code.match(/\d\d\d\d00/))
   parent_code=code[0,2]+"0000"  
  $catename[code]=name
  $catetree[parent_code][code]={}
 else
     parent_code=code[0,4]+"00"
     ancient_code=code[0,2]+"0000"
     $catetree[ancient_code][parent_code][code]=name
 end
   $cargo_category_two[code]=name
  
  end
  

  end

end

load_cargo_category_to_hash
$catetree.freeze
$catename.freeze