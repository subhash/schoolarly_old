class CreateTeachers < ActiveRecord::Migration
  def self.up
    create_table :teachers do |t|
      t.integer :school_id
      t.text :qualifications
      t.timestamps
      
      t.foreign_key :school_id, :schools, :id
    end
  end

  def self.down
    drop_table :teachers
  end
end
