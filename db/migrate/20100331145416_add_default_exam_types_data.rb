class AddDefaultExamTypesData < ActiveRecord::Migration
  def self.up
     ExamType.create(:name => 'SA1', :assessment_type => 'SA', :term => '1', :activity => 'Exam', :extendable => false) 
     ExamType.create(:name => 'SA2', :assessment_type => 'SA', :term => '2', :activity => 'Exam', :extendable => false)
     ExamType.create(:name => 'FA1', :assessment_type => 'FA', :term => '1', :activity => 'Class Test', :extendable => true)
     ExamType.create(:name => 'FA2', :assessment_type => 'FA', :term => '1', :activity => 'Class Test', :extendable => true)
     ExamType.create(:name => 'FA3', :assessment_type => 'FA', :term => '2', :activity => 'Class Test', :extendable => true)
     ExamType.create(:name => 'FA4', :assessment_type => 'FA', :term => '2', :activity => 'Class Test', :extendable => true)
     ExamType.create(:name => 'FA1', :assessment_type => 'FA', :term => '1', :activity => 'Project', :extendable => false)
     ExamType.create(:name => 'FA2', :assessment_type => 'FA', :term => '1', :activity => 'Project', :extendable => false)
     ExamType.create(:name => 'FA3', :assessment_type => 'FA', :term => '2', :activity => 'Project', :extendable => false)
     ExamType.create(:name => 'FA4', :assessment_type => 'FA', :term => '2', :activity => 'Project', :extendable => false)
     ExamType.create(:name => 'FA1', :assessment_type => 'FA', :term => '1', :activity => 'Assignment', :extendable => true)
     ExamType.create(:name => 'FA2', :assessment_type => 'FA', :term => '1', :activity => 'Assignment', :extendable => true)
     ExamType.create(:name => 'FA3', :assessment_type => 'FA', :term => '2', :activity => 'Assignment', :extendable => true)
     ExamType.create(:name => 'FA4', :assessment_type => 'FA', :term => '2', :activity => 'Assignment', :extendable => true)
     ExamType.create(:name => 'FA1', :assessment_type => 'FA', :term => '1', :activity => 'Seminar', :extendable => false)
     ExamType.create(:name => 'FA2', :assessment_type => 'FA', :term => '1', :activity => 'Seminar', :extendable => false)
     ExamType.create(:name => 'FA3', :assessment_type => 'FA', :term => '2', :activity => 'Seminar', :extendable => false)
     ExamType.create(:name => 'FA4', :assessment_type => 'FA', :term => '2', :activity => 'Seminar', :extendable => false)
     ExamType.create(:name => 'FA1', :assessment_type => 'FA', :term => '1', :activity => 'Practical', :extendable => false)
     ExamType.create(:name => 'FA2', :assessment_type => 'FA', :term => '1', :activity => 'Practical', :extendable => false)
     ExamType.create(:name => 'FA3', :assessment_type => 'FA', :term => '2', :activity => 'Practical', :extendable => false)
     ExamType.create(:name => 'FA4', :assessment_type => 'FA', :term => '2', :activity => 'Practical', :extendable => false)
     ExamType.create(:name => 'FA1', :assessment_type => 'FA', :term => '1', :activity => 'Record', :extendable => false)
     ExamType.create(:name => 'FA2', :assessment_type => 'FA', :term => '1', :activity => 'Record', :extendable => false)
     ExamType.create(:name => 'FA3', :assessment_type => 'FA', :term => '2', :activity => 'Record', :extendable => false)
     ExamType.create(:name => 'FA4', :assessment_type => 'FA', :term => '2', :activity => 'Record', :extendable => false)
     ExamType.create(:name => 'FA1', :assessment_type => 'FA', :term => '1', :activity => 'Collection', :extendable => false)
     ExamType.create(:name => 'FA2', :assessment_type => 'FA', :term => '1', :activity => 'Collection', :extendable => false)
     ExamType.create(:name => 'FA3', :assessment_type => 'FA', :term => '2', :activity => 'Collection', :extendable => false)
     ExamType.create(:name => 'FA4', :assessment_type => 'FA', :term => '2', :activity => 'Collection', :extendable => false)
  end

  def self.down
    ExamType.delete_all
  end
end
