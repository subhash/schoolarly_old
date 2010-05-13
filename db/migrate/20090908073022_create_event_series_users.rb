class CreateEventSeriesUsers < ActiveRecord::Migration
  def self.up
      create_table :event_series_users, :id => false do |t|
        t.integer :event_series_id, :null => false
        t.integer :user_id, :null => false
      
        t.timestamps
      
        t.foreign_key :event_series_id, :event_series, :id
        t.foreign_key :user_id, :users, :id
    end
    add_index :event_series_users, [ :event_series_id, :user_id], :unique => true
  end

  def self.down
    drop_table :event_series_users
  end
end