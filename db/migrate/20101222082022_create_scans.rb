class CreateScans < ActiveRecord::Migration
  def self.up
    create_table :scans do |t|
      t.integer :total_user
      t.integer :total_stock_truck
      t.integer :total_stock_cargo
      t.integer :idle_stock_truck
      t.integer :idle_stock_cargo
      t.integer :total_cargo
      t.integer :total_truck
      t.integer :expired_cargo
      t.integer :expired_truck
      t.integer :chenjiao_truck
      t.integer :chenjiao_cargo
      t.integer :total_line
      t.integer :total_company
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :scans
  end
end
