class LineAd
   include Mongoid::Document
   include Mongoid::Timestamps
      field :line,:type=>String
      field :fcity_name,:type=>String
      field :tcity_name,:type=>String
      field :company_name,:type=>String
      field :url,:type=>String
      field :one_word,:type=>String
      field :contact_phone,:type=>String
      field :user_id
      field :company_id
      field :lstatistic_id

end
