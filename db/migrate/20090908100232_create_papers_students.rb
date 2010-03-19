class CreatePapersStudents < ActiveRecord::Migration
  def self.up
    create_table :papers_students, :id => false do |t|
      t.integer :student_id, :null => false
      t.integer :paper_id, :null => false
      
      t.timestamps
      
      t.foreign_key :student_id, :students, :id
      t.foreign_key :paper_id, :papers, :id
    end
    add_index :papers_students, [ :student_id, :paper_id], :unique => true
  end
  
  def self.down
    drop_table :papers_students
  end
end
