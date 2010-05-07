class CreateKlasses < ActiveRecord::Migration
  def self.up
    create_table :klasses do |t|
      t.integer :level_id, :null => false
      t.string :division
      t.integer :school_id, :null => false
      t.integer :teacher_id
      t.timestamps
      
      t.foreign_key :school_id, :schools, :id
      t.foreign_key :teacher_id, :teachers, :id
      t.foreign_key :level_id, :levels, :id
    end
  end
  
  def self.down
    drop_table :klasses
  end
end
