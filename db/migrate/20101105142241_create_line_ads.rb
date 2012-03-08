class CreateLineAds < ActiveRecord::Migration
  def self.up
    create_table :line_ads do |t|
      t.string :line
      t.string :fcity_name
      t.string :tcity_name
      t.string :company_name
      t.string :url
      t.string :one_word
      t.string :contact_phone
      t.integer :user_id
      t.integer :company_id
      t.string :lstatistic_id

      t.timestamps
    end
  end

  def self.down
    drop_table :line_ads
  end
end
