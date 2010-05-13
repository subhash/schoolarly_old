class CreateEventSeries < ActiveRecord::Migration
  def self.up
    create_table :event_series do |t|
      t.integer :frequency
      t.string :period      
      t.integer :user_id
      
      t.timestamps
      
      t.foreign_key :user_id, :users, :id
    end
  end
  
  def self.down
    drop_table :event_series
  end
end