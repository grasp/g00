class CreateUstatistics < ActiveRecord::Migration
  def self.up
    create_table :ustatistics do |t|
      t.integer :total_stock_cargo
      t.integer :total_stock_truck
      t.integer :total_cargo
      t.integer :total_truck
      t.integer :total_line
      t.integer :total_driver
      t.integer :total_custermer
      t.integer :user_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :ustatistics
  end
end
