class CreateEventsUsers < ActiveRecord::Migration
  def self.up
      create_table :events_users, :id => false do |t|
        t.integer :event_id, :null => false
        t.integer :user_id, :null => false
      
        t.timestamps
      
        t.foreign_key :event_id, :events, :id
        t.foreign_key :user_id, :users, :id
    end
    add_index :events_users, [ :event_id, :user_id], :unique => true
  end

  def self.down
    drop_table :events_users
  end
end