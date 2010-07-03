class CreateAssessments < ActiveRecord::Migration
  def self.up
    create_table :assessments do |t|
      t.integer :assessment_type_id
      t.integer :klass_id
      t.integer :subject_id
      t.decimal :weightage
      t.integer :academic_year_id
      t.integer :teacher_id
      
      t.foreign_key :assessment_type_id, :assessment_types, :id
      t.foreign_key :klass_id, :klasses, :id
      t.foreign_key :subject_id, :subjects, :id
      t.foreign_key :academic_year_id, :academic_years, :id
      t.foreign_key :teacher_id, :teachers, :id

      t.timestamps
    end
  end

  def self.down
    drop_table :assessments
  end
end
