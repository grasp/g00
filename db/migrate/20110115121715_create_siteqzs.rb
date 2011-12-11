class CreateSiteqzs < ActiveRecord::Migration
  def self.up
    create_table :siteqzs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :siteqzs
  end
end
