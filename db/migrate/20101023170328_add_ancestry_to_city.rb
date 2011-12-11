class AddAncestryToCity < ActiveRecord::Migration
def self.up
    add_column :cities, :ancestry, :string
    add_column :cities, :ancestry_depth, :integer, :default => 0
    add_index :cities, :ancestry
  end

  def self.down
    remove_column :cities, :ancestry
    remove_column :cities, :ancestry_depth, :integer, :default => 0
    remove_index :cities, :ancestry
  end
end
