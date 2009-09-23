class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :country
      t.string :pincode
      t.string :phone_landline
      t.string :phone_mobile
      t.string :email
      t.string :hashed_password
      t.string :salt
      t.integer :person_id
      t.string :person_type

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
