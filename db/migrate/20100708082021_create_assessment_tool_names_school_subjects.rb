class CreateAssessmentToolNamesSchoolSubjects < ActiveRecord::Migration
  def self.up
    create_table :assessment_tool_names_school_subjects , :id => false do |t|
      t.integer :assessment_tool_name_id, :null=>false
      t.integer :school_subject_id, :null=>false
      t.foreign_key :assessment_tool_name_id, :assessment_tool_names, :id
      t.foreign_key :school_subject_id, :school_subjects, :id
    end
  end
  
  def self.down
    drop_table :assessment_tool_names_school_subjects
  end
end
