class CreateSchoolsSubjects < ActiveRecord::Migration
  def self.up
    create_table :schools_subjects, :id => false do |t|
      t.integer :school_id, :null=>false
      t.integer :subject_id, :null=>false
      t.foreign_key :school_id, :schools, :id
      t.foreign_key :subject_id, :subjects, :id
    end
    
    add_index :schools_subjects, [ :school_id, :subject_id], :unique => true
  end
  
  def self.down
    drop_table :schools_subjects
  end
end
