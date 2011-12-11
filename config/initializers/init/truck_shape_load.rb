# coding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

def load_shape_usage
      $truck_shape=Hash.new
      $truck_shape_reverse=Hash.new
        filename=File.dirname(__FILE__)+File::SEPARATOR+"truck_shape.txt"
      open(filename).each do |line|
        if line.size >0
          user=line.force_encoding("utf-8").split(/\s/)
          $truck_shape[user[0]]=user[1].force_encoding("utf-8")
          $truck_shape_reverse[user[1].force_encoding("utf-8")]=user[0]
         end
      end
  end

load_shape_usage

