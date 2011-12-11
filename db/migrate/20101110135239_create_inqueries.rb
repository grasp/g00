class CreateInqueries < ActiveRecord::Migration
  def self.up
    create_table :inqueries do |t|
      #basic info
      t.integer :price
      t.string :comments

      #status
      t.string :status

   # foreign data
      t.integer :cargo_id
      t.integer :truck_id
      t.integer :truck_company_id
      t.integer :truck_user_id
      t.integer :cargo_company_id
      t.integer :cargo_user_id
       t.integer :user_id
      
#feature usage
      t.integer :ismailed
      t.integer :isaccepted

      t.timestamps
    end
  end

  def self.down
    drop_table :inqueries
  end
end
