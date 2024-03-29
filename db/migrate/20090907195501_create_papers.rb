class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.integer :klass_id
      t.integer :school_subject_id
      t.integer :teacher_id

      t.timestamps
      
      t.foreign_key :klass_id, :klasses, :id      
      t.foreign_key :school_subject_id, :school_subjects, :id      
      t.foreign_key :teacher_id, :teachers, :id
    end
  end

  def self.down
    drop_table :papers
  end
end
