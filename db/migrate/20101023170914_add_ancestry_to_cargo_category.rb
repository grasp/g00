class AddAncestryToCargoCategory < ActiveRecord::Migration
  def self.up
    add_column :cargo_categories, :ancestry, :string
    add_column :cargo_categories, :ancestry_depth, :integer, :default => 0
    add_index :cargo_categories, :ancestry

  end

  def self.down
    remove_column :cargo_categories, :ancestry
    remove_column :cargo_categories, :ancestry_depth, :integer, :default => 0
    remove_index :cargo_categories, :ancestry
  end
end
