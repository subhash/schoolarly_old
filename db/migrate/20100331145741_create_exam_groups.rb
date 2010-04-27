class CreateExamGroups < ActiveRecord::Migration
  def self.up
    create_table :exam_groups do |t|
      t.string :description
      
      t.integer :exam_type_id, :null => false
      t.integer :klass_id, :null => false

      t.timestamps
            
      t.foreign_key :exam_type_id, :exam_types, :id
      t.foreign_key :klass_id, :klasses, :id

    end
  end

  def self.down
    drop_table :exam_groups
  end
end
