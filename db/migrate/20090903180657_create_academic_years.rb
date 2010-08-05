class CreateAcademicYears < ActiveRecord::Migration
  def self.up
    create_table :academic_years do |t|
      t.date :start_date
      t.date :end_date
      t.integer :school_id

      t.timestamps
      t.foreign_key :school_id, :schools, :id
    end
  end

  def self.down
    drop_table :academic_years
  end
end
