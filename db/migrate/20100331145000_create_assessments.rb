class CreateAssessments < ActiveRecord::Migration
  def self.up
    create_table :assessments do |t|
      t.string :assessment_type
      t.string :name
      t.string :term
      t.integer :max_score
      t.decimal :weightage, :precision => 3, :scale => 2, :default =>  1
      t.timestamps
    end
  end

  def self.down
    drop_table :assessments
  end
end
