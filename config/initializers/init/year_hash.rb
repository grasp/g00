
# To change this template, choose Tools | Templates
# and open the template in the editor.

   $year_hash=Hash.new
   $year_hash_reverse=Hash.new
   i=0
  2011.downto(1990).each do |year|

  $year_hash[i]=year
  $year_hash_reverse[year]=i
  i=i+1


  end

