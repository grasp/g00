class CreateUserContacts < ActiveRecord::Migration
  def self.up
    create_table :user_contacts do |t|
      t.string :name
      t.string :email
      t.string :mphone
      t.string :quhao
      t.string :fixphone     
      t.string :QQ
      t.string :website
      t.string :city_name
      t.string :city_code
      t.string :address
      t.integer :company_id
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :user_contacts
  end
end
