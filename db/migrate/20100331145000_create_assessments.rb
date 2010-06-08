class CreateAssessments < ActiveRecord::Migration
  def self.up
    create_table :assessments do |t|
      t.string :assessment_type
      t.string :name
      t.string :term
      t.integer :max_score
      t.decimal :weightage
      t.timestamps
    end
  end

  def self.down
    drop_table :assessments
  end
end
