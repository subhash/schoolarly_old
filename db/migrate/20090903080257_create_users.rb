class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
#      t.string :first_name
#      t.string :middle_name
#      t.string :last_name
#      t.string :address_line1
#      t.string :address_line2
#      t.string :city
#      t.string :state
#      t.string :country
#      t.string :pincode
#      t.string :phone_landline
#      t.string :phone_mobile      
      t.integer :person_id, :null => false
      t.string :person_type, :null => false
      
      t.string :email
      t.string :crypted_password
      t.string :password_salt      

      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::Perishability      
      
      # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
      t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
