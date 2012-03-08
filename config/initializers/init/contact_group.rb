# coding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.

def load_contact_group
      $contact_group=Hash.new
      $contact_reverse_group=Hash.new
        filename=File.dirname(__FILE__)+File::SEPARATOR+"contact_group.txt"
      open(filename).each do |line|
        if line.size >0
          user=line.force_encoding("utf-8").split(/\s/)
          $contact_group[user[0]]=user[1].force_encoding("utf-8")
          $contact_reverse_group[user[1].force_encoding("utf-8")]=user[0]
         end
      end
  end

load_contact_group

