class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.string :board, :default => 'CBSE'
      t.string :fax
      t.string :website
      t.integer :academic_year_id
      
      t.timestamps
      t.foreign_key :academic_year_id, :academic_years, :id
    end
  end
  
  def self.down
    drop_table :schools
  end
end
