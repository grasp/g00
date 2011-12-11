class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.text :about
      t.integer :self_che
      t.integer :signed_che
      t.integer :num_employ
      t.string :contact_name
      t.string :city_name
      t.string :city_code
      t.string :city_id
      t.string :address
      t.string :fix_phone
      t.string :mobile_phone
      t.string :email
      t.string :company_license_id
      t.string :user_name
      t.integer :user_id
      t.integer :ispersonal
      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
