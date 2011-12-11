class CreateStockTrucks < ActiveRecord::Migration
  def self.up
    create_table :stock_trucks do |t|

      #stock truck basic info
      t.string :paizhao
      t.string :dun_wei
      t.string :che_length
      t.string :truck_usage
      t.string :truck_shape
      t.string :truck_gps

      #Manufacture info
      t.string :truck_pinpai
      t.string :truck_xinghao
      t.string :truck_year


      #driver info
      t.string :driver_name
      t.string :driver_phone
      
      t.string :owner_name
      t.string :owner_phone

      # contact inforamtion
      t.integer :company_id
      t.string :car_phone
      t.integer :user_id

      #status
      t.string :status

      # for feature usage
      t.integer :truck_license_id
      t.integer :truck_owner_id

      t.timestamps
    end
  end

  def self.down
    drop_table :stock_trucks
  end
end
