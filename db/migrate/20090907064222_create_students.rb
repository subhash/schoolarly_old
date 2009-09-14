class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students , :force=> true do |t|
      t.integer :school_id
      t.string :admission_number
      t.integer :current_enrollment_id
      t.timestamps
      
      t.foreign_key :school_id, :schools, :id      
    end
  end
  
  def self.down
    drop_table :students
  end
end
