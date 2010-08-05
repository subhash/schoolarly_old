class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.string :board, :default => 'CBSE'
      t.string :fax
      t.string :website
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :schools
  end
end
