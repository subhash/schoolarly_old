class AddDefaultExamTypesData < ActiveRecord::Migration
  def self.up
     ExamType.create(:name => 'SA1', :description => 'Term 1 - Summative Assessment', :assessment_type => 'SA', :term => '1', :fa_type => nil) 
     ExamType.create(:name => 'SA2', :description => 'Term 2 - Summative Assessment', :assessment_type => 'SA', :term => '2', :fa_type => nil)
     ExamType.create(:name => 'FA1 Class Test', :description => 'Class Test - Formative Assessment 1', :assessment_type => 'FA', :term => '1', :fa_type => 'Class Test')
     ExamType.create(:name => 'FA2 Class Test', :description => 'Class Test - Formative Assessment 2', :assessment_type => 'FA', :term => '1', :fa_type => 'Class Test')
     ExamType.create(:name => 'FA3 Class Test', :description => 'Class Test - Formative Assessment 3', :assessment_type => 'FA', :term => '2', :fa_type => 'Class Test')
     ExamType.create(:name => 'FA4 Class Test', :description => 'Class Test - Formative Assessment 4', :assessment_type => 'FA', :term => '2', :fa_type => 'Class Test')
     ExamType.create(:name => 'FA1 Project', :description => 'Project - Formative Assessment 1', :assessment_type => 'FA', :term => '1', :fa_type => 'Project')
     ExamType.create(:name => 'FA2 Project', :description => 'Project - Formative Assessment 2', :assessment_type => 'FA', :term => '1', :fa_type => 'Project')
     ExamType.create(:name => 'FA3 Project', :description => 'Project - Formative Assessment 3', :assessment_type => 'FA', :term => '2', :fa_type => 'Project')
     ExamType.create(:name => 'FA4 Project', :description => 'Project - Formative Assessment 4', :assessment_type => 'FA', :term => '2', :fa_type => 'Project')
     ExamType.create(:name => 'FA1 Assignment', :description => 'Assignment - Formative Assessment 1', :assessment_type => 'FA', :term => '1', :fa_type => 'Assignment')
     ExamType.create(:name => 'FA2 Assignment', :description => 'Assignment - Formative Assessment 2', :assessment_type => 'FA', :term => '1', :fa_type => 'Assignment')
     ExamType.create(:name => 'FA3 Assignment', :description => 'Assignment - Formative Assessment 3', :assessment_type => 'FA', :term => '2', :fa_type => 'Assignment')
     ExamType.create(:name => 'FA4 Assignment', :description => 'Assignment - Formative Assessment 4', :assessment_type => 'FA', :term => '2', :fa_type => 'Assignment')
     ExamType.create(:name => 'FA1 Seminar', :description => 'Seminar - Formative Assessment 1', :assessment_type => 'FA', :term => '1', :fa_type => 'Seminar')
     ExamType.create(:name => 'FA2 Seminar', :description => 'Seminar - Formative Assessment 2', :assessment_type => 'FA', :term => '1', :fa_type => 'Seminar')
     ExamType.create(:name => 'FA3 Seminar', :description => 'Seminar - Formative Assessment 3', :assessment_type => 'FA', :term => '2', :fa_type => 'Seminar')
     ExamType.create(:name => 'FA4 Seminar', :description => 'Seminar - Formative Assessment 4', :assessment_type => 'FA', :term => '2', :fa_type => 'Seminar')
     ExamType.create(:name => 'FA1 Practical', :description => 'Practical - Formative Assessment 1', :assessment_type => 'FA', :term => '1', :fa_type => 'Practical')
     ExamType.create(:name => 'FA2 Practical', :description => 'Practical - Formative Assessment 2', :assessment_type => 'FA', :term => '1', :fa_type => 'Practical')
     ExamType.create(:name => 'FA3 Practical', :description => 'Practical - Formative Assessment 3', :assessment_type => 'FA', :term => '2', :fa_type => 'Practical')
     ExamType.create(:name => 'FA4 Practical', :description => 'Practical - Formative Assessment 4', :assessment_type => 'FA', :term => '2', :fa_type => 'Practical')
     ExamType.create(:name => 'FA1 Record', :description => 'Record - Formative Assessment 1', :assessment_type => 'FA', :term => '1', :fa_type => 'Record')
     ExamType.create(:name => 'FA2 Record', :description => 'Record - Formative Assessment 2', :assessment_type => 'FA', :term => '1', :fa_type => 'Record')
     ExamType.create(:name => 'FA3 Record', :description => 'Record - Formative Assessment 3', :assessment_type => 'FA', :term => '2', :fa_type => 'Record')
     ExamType.create(:name => 'FA4 Record', :description => 'Record - Formative Assessment 4', :assessment_type => 'FA', :term => '2', :fa_type => 'Record')
     ExamType.create(:name => 'FA1 Collection', :description => 'Collection - Formative Assessment 1', :assessment_type => 'FA', :term => '1', :fa_type => 'Collection')
     ExamType.create(:name => 'FA2 Collection', :description => 'Collection - Formative Assessment 2', :assessment_type => 'FA', :term => '1', :fa_type => 'Collection')
     ExamType.create(:name => 'FA3 Collection', :description => 'Collection - Formative Assessment 3', :assessment_type => 'FA', :term => '2', :fa_type => 'Collection')
     ExamType.create(:name => 'FA4 Collection', :description => 'Collection - Formative Assessment 4', :assessment_type => 'FA', :term => '2', :fa_type => 'Collection')
  end

  def self.down
    ExamType.delete_all
  end
end
