class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams do |t|
      t.date :exam_date
      t.time :start_time
      t.time :end_time
      t.string :venue
      t.integer :max_score
      t.integer :pass_score
      
      t.integer :exam_group_id, :null => false
      t.integer :subject_id, :null => false

      t.timestamps
      
      t.foreign_key :exam_group_id, :exam_groups, :id, :on_delete => :cascade
      t.foreign_key :subject_id, :subjects, :id      
    end
  end

  def self.down
    drop_table :exams
  end
end
