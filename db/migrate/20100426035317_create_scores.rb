class CreateScores < ActiveRecord::Migration
  def self.up
    create_table :scores do |t|
      t.integer :student_id, :null => false
      t.integer :exam_id, :null => false
      t.decimal :score, :precision => 5, :scale => 2

      t.timestamps
      
      t.foreign_key :exam_id, :exams, :id
      t.foreign_key :student_id, :students, :id
    end
  end

  def self.down
    drop_table :scores
  end
end
