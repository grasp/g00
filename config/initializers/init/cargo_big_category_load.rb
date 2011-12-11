#coding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

def load_cargo_big_category
      $cargo_big_category=Hash.new
    $cargo_big_category_reverse=Hash.new
        filename=File.dirname(__FILE__)+File::SEPARATOR+"cargo_big_category.txt"
      open(filename).each do |line|
        if line.size >0
          user=line.force_encoding("utf-8").split(/\s/)
        $cargo_big_category[user[0]]=user[1].force_encoding("utf-8")
        $cargo_big_category_reverse[user[1].force_encoding("utf-8")]=user[0]
        end
      end
  end

load_cargo_big_category

#$cargo_big_category.each do |key,value|
  
 # puts "cargo_big_category：#{key}=#{value}"
#end

