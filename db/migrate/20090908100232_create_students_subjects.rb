class CreateStudentsSubjects < ActiveRecord::Migration
  def self.up
    create_table :students_subjects, :id => false do |t|
      t.integer :student_id, :null => false
      t.integer :subject_id, :null => false
      
      t.timestamps
      
      t.foreign_key :student_id, :students, :id
      t.foreign_key :subject_id, :subjects, :id
    end
    add_index :students_subjects, [ :student_id, :subject_id], :unique => true
  end
  
  def self.down
    drop_table :students_subjects
  end
end
