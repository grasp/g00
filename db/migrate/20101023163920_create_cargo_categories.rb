class CreateCargoCategories < ActiveRecord::Migration
  def self.up
    create_table :cargo_categories do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :cargo_categories
  end
end
