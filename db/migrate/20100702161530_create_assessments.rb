class CreateAssessments < ActiveRecord::Migration
  def self.up
    create_table :assessments do |t|
      t.integer :subject_id, :null => false
      t.integer :assessment_group_id, :null => false
      
      t.foreign_key :subject_id, :subjects, :id
      t.foreign_key :assessment_group_id, :assessment_groups, :id
      t.timestamps
    end
  end

  def self.down
    drop_table :assessments
  end
end
