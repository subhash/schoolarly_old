class CreateRoles < ActiveRecord::Migration

  def self.up
    create_table :roles, :force => true do |t|
      t.string  :name, :authorizable_type, :limit => 40
      t.integer :authorizable_id
      t.timestamps
    end
    
    create_table :roles_users, :id => false, :force => true  do |t|
      t.integer :user_id, :role_id
      t.timestamps      
      t.foreign_key :user_id, :users, :id
      t.foreign_key :role_id, :roles, :id
    end


  end

  def self.down
    drop_table :roles_users
    drop_table :roles    
  end

end
