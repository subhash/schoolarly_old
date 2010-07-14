class CreateAssessmentTools < ActiveRecord::Migration
  def self.up
    create_table :assessment_tools do |t|
      t.string :name
      t.integer :assessment_id, :null => false
      t.integer :ignore_worst, :default => 0 
      t.decimal :weightage
                 
      t.foreign_key :assessment_id, :assessments, :id

      t.timestamps
    end
  end

  def self.down
    drop_table :assessment_tools
  end
end
