module ConcerncargosHelper
     def split_array(array,n)
   new_array=Array.new
   array_size=array.size
    small_array= Array.new  
    0.upto(array_size-1).each do |i|  
    small_array<< array[i] unless  array[i].nil?
      if (i+1)%n==0 
      new_array<<small_array
      small_array= Array.new        
      end     
    
    end   
   new_array
 end
end
