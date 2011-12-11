class CreateTstatistics < ActiveRecord::Migration
  def self.up
    create_table :tstatistics do |t|
      t.integer :total_baojia
      t.integer :total_xunjia
      t.integer :total_match
      t.integer :total_click
      t.integer :user_id
      t.integer :truck_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tstatistics
  end
end
