class CreateStudentEnrollmentsSubjects < ActiveRecord::Migration
  def self.up
    create_table :student_enrollments_subjects, :id => false do |t|
      t.integer :student_enrollment_id, :null => false
      t.integer :subject_id, :null => false
      
      t.timestamps
      
      t.foreign_key :student_enrollment_id, :student_enrollments, :id
      t.foreign_key :subject_id, :subjects, :id
    end
    add_index :student_enrollments_subjects, [ :student_enrollment_id, :subject_id], :unique => true, :name=>'index_enrollment_subjects'
  end
  
  def self.down
    drop_table :student_enrollments_subjects
  end
end
