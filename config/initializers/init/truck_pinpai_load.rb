# coding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

def load_truck_usage
      $truck_pinpai=Hash.new
      $truck_pinpai_reverse=Hash.new
        filename=File.dirname(__FILE__)+File::SEPARATOR+"truck_pinpai.txt"
      open(filename).each do |line|
        if line.force_encoding("utf-8").size >0
          user=line.split(/\s/)
           $truck_pinpai[user[0]]=user[1].force_encoding("utf-8")
             $truck_pinpai_reverse[user[1].force_encoding("utf-8")]=user[0]
         end
      end
  end

load_truck_usage

