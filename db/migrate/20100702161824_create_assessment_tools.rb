class CreateAssessmentTools < ActiveRecord::Migration
  def self.up
    create_table :assessment_tools do |t|
      t.integer :assessment_tool_type_id
      t.integer :assessment_id
      t.integer :ignore_worst
      t.decimal :weightage
                 
      t.foreign_key :assessment_tool_type_id, :assessment_tool_types, :id
      t.foreign_key :assessment_id, :assessments, :id

      t.timestamps
    end
  end

  def self.down
    drop_table :assessment_tools
  end
end
