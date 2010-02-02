class CreateTeacherSubjectAllotments < ActiveRecord::Migration
  def self.up
    create_table :teacher_subject_allotments do |t|
      t.integer :teacher_id
      t.integer :school_id
      t.integer :subject_id

      t.timestamps
      
      t.foreign_key :teacher_id, :teachers, :id
      t.foreign_key :school_id, :schools, :id
      t.foreign_key :subject_id, :subjects, :id
    end
    add_index :teacher_subject_allotments, [:teacher_id, :school_id, :subject_id], :unique => true, :name=>'index_teacher_subject_allotments'
  end

  def self.down
    drop_table :teacher_subject_allotments
  end
end
