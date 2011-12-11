class CreateStockCargos < ActiveRecord::Migration
  def self.up
    create_table :stock_cargos do |t|

      #category related
      t.string :big_category
      t.string :cate_name
      t.string :cate_code

      #packakge related
      t.string :package_name
      t.string :package_code

      #cargo property and status
      t.string :cargo_property

      #expired/invalid/normal
      t.string :stock_status
      
      #weight and buld
      t.string :ku_weight
      t.string :ku_bulk
      t.integer :cangku_id
      
      t.string :sent_weight
      t.string :sent_bulk
      
     #define for search
      t.integer :user_id
      t.integer :company_id     
      t.integer :scstatistic_id

      #status
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :stock_cargos
  end
end
