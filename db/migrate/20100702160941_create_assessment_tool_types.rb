class CreateAssessmentToolTypes < ActiveRecord::Migration
  def self.up
    create_table :assessment_tool_types do |t|
      t.string :name, :null => false
      t.integer :school_subject_id, :null => false
      t.integer :assessment_type_id, :null => false
      
      t.foreign_key :school_subject_id, :school_subjects, :id
      t.foreign_key :assessment_type_id, :assessment_types, :id
      t.timestamps
    end
  end

  def self.down
    drop_table :assessment_tool_types
  end
end
