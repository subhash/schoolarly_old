class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students , :force=> true do |t|
      t.integer :school_id
      t.string :admission_number
      t.integer :enrollment_id
      t.timestamps
      
      t.foreign_key :school_id, :schools, :id
      #t.foreign_key :enrollment_id, :student_enrollments, :id
    end
  end
  
  def self.down
    drop_table :students
  end
end
