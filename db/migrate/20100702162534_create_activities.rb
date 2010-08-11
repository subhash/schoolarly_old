class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer :position
      t.integer :assessment_tool_id
      t.string :description
      t.decimal :max_score, :precision => 6, :scale => 2
      t.integer :event_id
      
      t.foreign_key :assessment_tool_id, :assessment_tools, :id
      t.foreign_key :event_id, :events, :id
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :activities
  end
end
