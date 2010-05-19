class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :event_series_id, :null => false

      t.timestamps
      
      t.foreign_key :event_series_id, :event_series, :id
    end
  end

  def self.down
    drop_table :events
  end
end