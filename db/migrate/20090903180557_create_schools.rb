class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.string :name
      t.enum :board, :limit => [:cbse, :icse, :state, :others], :default => :cbse
      t.string :fax
      t.string :website
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :schools
  end
end
