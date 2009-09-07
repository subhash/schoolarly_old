class AddStudentEnrollmentForeignKey < ActiveRecord::Migration
  def self.up
    add_foreign_key :students, :enrollment_id,:student_enrollments, :id 
  end
  
  def self.down
    remove_foreign_key :students, :enrollment_id
  end
end
