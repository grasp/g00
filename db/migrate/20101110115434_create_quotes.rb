class CreateQuotes < ActiveRecord::Migration
  def self.up
    create_table :quotes do |t|

      #basic infor
      t.integer :price
      t.string :comments

      t.integer :cargo_id
      t.integer :truck_id
      t.integer :truck_user_id
      t.integer :truck_company_id
      t.integer :cargo_user_id
      t.integer :cargo_company_id
       t.integer :user_id

      #status of quotes
      t.string:status


      # for future usage
      t.integer :ismailed
      t.integer :isaccepted

      t.timestamps
    end
  end

  def self.down
    drop_table :quotes
  end
end
