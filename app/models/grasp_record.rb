# To change this template, choose Tools | Templates
# and open the template in the editor.

class GraspRecord
include Mongoid::Document
include Mongoid::Timestamps
      field :diff_che,:type=>Integer
      field :diff_huo,:type=>Integer
      field :cycle_che,:type=>Integer
      field :cycle_huo,:type=>Integer
      field :total_che,:type=>Integer
      field :total_huo,:type=>Integer      
      field :cost_time,:type=>String
      field :fail_counter,:type=>Integer
      field :succ_counter,:type=>Integer
      
      field :miss_field_huo,:type=>Integer
      field :miss_field_che,:type=>Integer      
      field :repeat_huo,:type=>Integer
      field :repeat_che,:type=>Integer
      field :cargos_lines,:type=>Array
      field :trucks_lines,:type=>Array
     # timestamps!    
end

