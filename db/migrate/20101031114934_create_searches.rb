class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.string :fcity_code
      t.string :fcity_name
      t.string :tcity_code
      t.string :tcity_name
      t.string :stype
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
