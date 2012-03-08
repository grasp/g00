class CreateCargos < ActiveRecord::Migration
  def self.up
    create_table :cargos do |t|
      
      # cargo self info
      t.string :cargo_weight
      t.string :cargo_zuhuo
      t.string :cargo_bulk
      t.string :send_date
      t.string :comments
      t.string :status

      #for not go back to find stock_cargo
      t.string :cate_name
      t.string :package_name
      t.string :big_category

      # important line info
      t.string :line
      t.string :fcity_name
      t.string :tcity_name
      t.string:fcity_code
      t.string:tcity_code
      
      # for contact
      t.integer :user_id
      t.integer :company_id
      t.integer :stock_cargo_id
      t.integer :user_contact_id

      #important information
      t.string :zhuang_addr
      t.string :zhuang_time
      t.string :xie_addr

      #future usage
      t.integer :pingjia_id
      t.integer :cstatistic_id

     
       
      t.timestamps
    end
  end

  def self.down
    drop_table :cargos
  end
end
