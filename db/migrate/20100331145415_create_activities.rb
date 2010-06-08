class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :activity
      t.boolean :extendable
      t.integer :assessment_id
      t.timestamps
      
      t.foreign_key :assessment_id, :assessments, :id
    end
  end

  def self.down
    drop_table :activities
  end
end
