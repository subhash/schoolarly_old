class CreateTeacherKlassAllotments < ActiveRecord::Migration
  def self.up
    create_table :teacher_klass_allotments do |t|
      t.integer :teacher_subject_allotment_id
      t.integer :klass_id
      t.date :start_date
      t.date :end_date
      
      t.timestamps
      
      t.foreign_key :teacher_subject_allotment_id, :teacher_subject_allotments, :id, :on_delete => :cascade
      t.foreign_key :klass_id, :klasses, :id
      
    end
  end

  def self.down
    drop_table :teacher_klass_allotments
  end
end
