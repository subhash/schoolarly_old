class CreateAssessmentTypes < ActiveRecord::Migration
  def self.up
     create_table :assessment_types do |t|
      t.string :name, :null => false
      t.integer :term, :null => false
      t.decimal :max_score, :scale => 2
      t.decimal :weightage, :precision => 5, :scale => 2
      t.timestamps
    end
  end

  def self.down
     drop_table :assessment_types
  end
end
