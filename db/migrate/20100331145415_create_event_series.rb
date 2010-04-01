class CreateEventSeries < ActiveRecord::Migration
  def self.up
    create_table :event_series do |t|
      t.integer :frequency
      t.string :period
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :all_day

      t.timestamps
    end
  end

  def self.down
    drop_table :event_series
  end
end