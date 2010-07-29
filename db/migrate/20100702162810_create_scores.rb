class CreateScores < ActiveRecord::Migration
  def self.up
    create_table :scores do |t|
      t.integer :activity_id
      t.integer :student_id
      t.decimal :score, :precision => 6, :scale => 2
      
      t.foreign_key :activity_id, :activities, :id
      t.foreign_key :student_id, :students, :id
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :scores
  end
end
