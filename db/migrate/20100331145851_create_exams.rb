class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams do |t|
      t.string :description
      t.integer :exam_type_id, :null => false
      t.integer :subject_id, :null => false
      t.integer :event_id
      t.integer :klass_id, :null => false
      t.integer :teacher_id
      t.integer :academic_year_id
      t.timestamps
      
      t.foreign_key :exam_type_id, :exam_types, :id
      t.foreign_key :subject_id, :subjects, :id  
      t.foreign_key :event_id, :events, :id
      t.foreign_key :klass_id, :klasses, :id
      t.foreign_key :teacher_id, :teachers, :id
      t.foreign_key :academic_year_id, :academic_years, :id
    end
  end

  def self.down
    drop_table :exams
  end
end
