class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.integer :klass_id
      t.integer :subject_id
      t.integer :teacher_id

      t.timestamps
      
      t.foreign_key :klass_id, :klasses, :id      
      t.foreign_key :subject_id, :subjects, :id      
      t.foreign_key :teacher_id, :teachers, :id
    end
  end

  def self.down
    drop_table :papers
  end
end
