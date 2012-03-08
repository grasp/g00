# To change this template, choose Tools | Templates
# and open the template in the editor.

class  CompanyGrasp
   include Mongoid::Document
   include Mongoid::Timestamps
        
   # cargo self info
      field :total_grasp, :type=>Integer
      field :valid_grasp, :type=>Integer
      field :invalid_grasp, :type=>Integer
      field :repeated_grasp, :type=>Integer
      field :from_site,:type=>String
      field :duration,:type=>String
      
     
end

