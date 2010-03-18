class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students , :force=> true do |t|
      t.integer :school_id
      t.string :admission_number
      t.string :roll_number
      t.integer :klass_id
      t.timestamps
      
      t.foreign_key :school_id, :schools, :id   
      t.foreign_key :klass_id, :klasses, :id    
    end
  end
  
  def self.down
    drop_table :students
  end
end
