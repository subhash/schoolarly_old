class CreateQualifications < ActiveRecord::Migration
  def self.up
    create_table :qualifications do |t|
      t.string :degree
      t.string :subject
      t.string :university
      t.date :date
      t.integer :teacher_id, :null=>false      
      t.timestamps
      
      t.foreign_key :teacher_id, :teachers, :id
    end
  end
  
  def self.down
    drop_table :qualifications
  end
end
