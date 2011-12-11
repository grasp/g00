class CreateCstatistics < ActiveRecord::Migration
  def self.up
    create_table :cstatistics do |t|
      t.integer :total_baojia
      t.integer :total_xunjia
      t.integer :total_match
      t.integer :total_click
      t.integer :user_id
      t.integer :cargo_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cstatistics
  end
end
