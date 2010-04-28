class CreateUserProfiles < ActiveRecord::Migration
  def self.up
    create_table :user_profiles do |t|
      t.integer :user_id, :null=>false
      t.string :name
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :country
      t.string :pincode
      t.string :phone_landline
      t.string :phone_mobile

      t.timestamps
      
      t.foreign_key :user_id, :users, :id
    end
  end

  def self.down
    drop_table :user_profiles
  end
end
