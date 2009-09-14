class CreateKlassesSubjects < ActiveRecord::Migration
  def self.up
    create_table :klasses_subjects, :id => false do |t|
      t.integer :klass_id, :null=>false
      t.integer :subject_id, :null=>false
      t.foreign_key :klass_id, :klasses, :id
      t.foreign_key :subject_id, :subjects, :id
    end
    
    add_index :klasses_subjects, [ :klass_id, :subject_id], :unique => true
  end
  
  def self.down
    drop_table :klasses_subjects
  end
end

