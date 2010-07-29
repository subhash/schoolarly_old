class CreateAssessmentTools < ActiveRecord::Migration
  def self.up
    create_table :assessment_tools do |t|
      t.string :name
      t.integer :assessment_id, :null => false
      t.integer :best_of, :default => 1 
      t.decimal :weightage, :precision => 5, :scale => 2
                 
      t.foreign_key :assessment_id, :assessments, :id

      t.timestamps
    end
  end

  def self.down
    drop_table :assessment_tools
  end
end
