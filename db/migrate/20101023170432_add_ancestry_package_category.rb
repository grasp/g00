class AddAncestryPackageCategory < ActiveRecord::Migration
  def self.up
   add_column :package_categories, :ancestry, :string
    add_column :package_categories, :ancestry_depth, :integer, :default => 0
    add_index :package_categories, :ancestry
  end

  def self.down
     remove_column :package_categories, :ancestry
     remove_column :package_categories, :ancestry_depth, :integer, :default => 0
      remove_index :package_categories, :ancestry
  end
end
