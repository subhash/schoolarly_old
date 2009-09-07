class CreateStudentEnrollments < ActiveRecord::Migration
  def self.up
    create_table :student_enrollments do |t|
      t.integer :student_id, :null => false
      t.integer :klass_id, :null => false
      t.string :admission_number
      t.string :roll_number
      t.date :enrollment_date
      
      t.timestamps
      
      t.foreign_key :student_id, :students, :id
      t.foreign_key :klass_id, :klasses, :id
    end
    
    add_foreign_key :students, :current_enrollment_id,:student_enrollments, :id
  end
  
  def self.down
    drop_table :student_enrollments
    remove_foreign_key :students, :current_enrollment_id
  end
end
