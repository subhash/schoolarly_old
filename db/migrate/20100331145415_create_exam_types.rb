class CreateExamTypes < ActiveRecord::Migration
  def self.up
    create_table :exam_types do |t|
      t.string :name
      t.string :assessment_type
      t.string :term
      t.string :activity
      t.boolean :extendable
      t.timestamps
    end
  end

  def self.down
    drop_table :exam_types
  end
end
