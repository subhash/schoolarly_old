class CreateParents < ActiveRecord::Migration
  def self.up
    create_table :parents do |t|
      t.integer :student_id, :null => false
      
      t.timestamps
      
      t.foreign_key :student_id, :students, :id
    end
  end

  def self.down
    drop_table :parents
  end
end
