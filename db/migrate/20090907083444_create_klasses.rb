class CreateKlasses < ActiveRecord::Migration
  def self.up
    create_table :klasses do |t|
      t.enum :level, :limit => ['Pre-school', 'L.K.G','U.K.G','Mont1','Mont2','Mont3','1','2','3','4','5','6','7','8','9','10','11','12']
      t.string :division
      t.integer :school_id, :null => false
      t.integer :year
      t.integer :teacher_id
      t.timestamps
      
      t.foreign_key :school_id, :schools, :id
      t.foreign_key :teacher_id, :teachers, :id
    end
  end
  
  def self.down
    drop_table :klasses
  end
end
