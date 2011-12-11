class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :real_name
      t.string :hashed_password
      t.string :salt
      t.string :status
      t.string :activate
      
      t.integer :company_id
      t.integer :user_contact_id

      t.integer :ustatistic_id

      t.integer :preference
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
