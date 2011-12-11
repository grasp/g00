class Search 
   include Mongoid::Document
   include Mongoid::Timestamps
        cattr_reader :per_page
        @@per_page = 10
    field :fcity_code,:type=>String
    field :fcity_name,:type=>String
    field :tcity_code,:type=>String
    field :tcity_name,:type=>String
    field :stype,:type=>String
    field :user_id
    
end
