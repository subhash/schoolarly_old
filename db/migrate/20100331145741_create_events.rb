class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :all_day
      t.integer :event_series_id
      t.integer :user_id

      t.timestamps
      
      t.foreign_key :event_series_id, :event_series, :id
      t.foreign_key :user_id, :users, :id
    end
  end

  def self.down
    drop_table :events
  end
end
