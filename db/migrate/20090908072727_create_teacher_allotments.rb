class CreateTeacherAllotments < ActiveRecord::Migration
  def self.up
    create_table :teacher_allotments do |t|
      t.integer :teacher_id, :null => false
      t.integer :subject_id, :null => false
      t.integer :klass_id, :null => false
      t.date :allotment_date
      t.boolean :is_current 
      
      t.timestamps
      
      t.foreign_key :teacher_id, :teachers, :id
      t.foreign_key :subject_id, :subjects, :id
      t.foreign_key :klass_id, :klasses, :id
    end
  end

  def self.down
    drop_table :teacher_allotments
  end
end
