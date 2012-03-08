# coding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

def load_cargo_option
      $cargo_option=Hash.new
      $cargo_option_reverse=Hash.new
        filename=File.dirname(__FILE__)+File::SEPARATOR+"cargo_option.txt"
      open(filename).each do |line|
        if line.size >0
          user=line.force_encoding("utf-8").split(/\s/)
          $cargo_option[user[0]]=user[1].force_encoding("utf-8")
          $cargo_option_reverse[user[1].force_encoding("utf-8")]=user[0]
         end
      end
  end

load_cargo_option


