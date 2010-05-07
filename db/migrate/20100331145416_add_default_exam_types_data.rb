class AddDefaultExamTypesData < ActiveRecord::Migration
  def self.up
    ExamType.create(:name => "Quarterly", :description => "Quarterly Test")
    ExamType.create(:name => "Annual", :description => "Annual Exam")
    ExamType.create(:name => "First Term", :description => "First Term Test")
    ExamType.create(:name => "Mid Term", :description => "Mid Term Test")
    ExamType.create(:name => "Last Term", :description => "Last Term Test")
    ExamType.create(:name => "Semester", :description => "Semester Test")
    ExamType.create(:name => "Class", :description => "Class Test")
    ExamType.create(:name => "Unit", :description => "Unit Test")
    ExamType.create(:name => "Model", :description => "Model Exam")
    ExamType.create(:name => "Pre-Model", :description => "Pre-Model Test")
    ExamType.create(:name => "Board", :description => "Board Exam")
    ExamType.create(:name => "Supplimentary", :description => "Supplimentary Exam")
    ExamType.create(:name => "Others", :description => "Uncategorised")    
  end

  def self.down
    ExamType.delete_all
  end
end
