class CreateTrucks < ActiveRecord::Migration
  def self.up
    create_table :trucks do |t|
     
      #repeat stock_truck info for not go back search
      t.string :paizhao
      t.string :dunwei
      t.string :length
      t.string :shape
      t.string :usage
      t.string :driver_name
      t.string :driver_phone
      t.string :car_phone

      #truck info
      t.string :send_date
      t.string :status
      t.string :comments
      t.string :huicheng

      #line info
      t.string :line
      t.string :fcity_name
      t.string :tcity_name
      t.string :fcity_code
      t.string :tcity_code

     
     # external search
      t.integer :company_id
      t.integer :user_id
      t.integer :stock_truck_id
      t.integer :user_contact_id
       
      #for future usage
      t.integer :truck_pingjia_id
      t.integer :truck_status_id
      t.integer :tstatistic_id
   
      t.timestamps
    end
  end

  def self.down
    drop_table :trucks
  end
end
