class CreateLstatistics < ActiveRecord::Migration
  def self.up
    create_table :lstatistics do |t|
      t.string :line
      t.integer :valid_cargo
      t.integer :valid_truck
      t.integer :total_cargo
      t.integer :total_truck

      t.timestamps
    end
  end

  def self.down
    drop_table :lstatistics
  end
end
