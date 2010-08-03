class CreateAssessmentGroups < ActiveRecord::Migration
  def self.up
    create_table :assessment_groups do |t|
      t.integer :assessment_type_id, :null => false
      t.integer :klass_id, :null => false
      t.decimal :max_score, :precision => 6, :scale => 2
      t.decimal :weightage, :precision => 5, :scale => 2
      t.integer :academic_year_id, :null => false
      
      t.foreign_key :assessment_type_id, :assessment_types, :id
      t.foreign_key :klass_id, :klasses, :id
      t.foreign_key :academic_year_id, :academic_years, :id
      t.timestamps
    end
  end

  def self.down
    drop_table :assessment_groups
  end
end
