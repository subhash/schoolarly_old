class CreateAssessmentToolNames < ActiveRecord::Migration
  def self.up
    create_table :assessment_tool_names do |t|
      t.string :name, :null => false
      t.integer :school_subject_id, :null => false
      t.string :assessment_type_name, :default => "FA"
      
      t.foreign_key :school_subject_id, :school_subjects, :id
      t.timestamps
    end
  end

  def self.down
    drop_table :assessment_tool_names
  end
end
