class CreateAssessmentToolNames < ActiveRecord::Migration
  def self.up
    create_table :assessment_tool_names do |t|
      t.string :name, :null => false
      t.string :assessment_type_name, :default => "FA"
      t.integer :school_id
      
      t.foreign_key :school_id, :schools, :id
      t.timestamps
    end
  end

  def self.down
    drop_table :assessment_tool_names
  end
end
