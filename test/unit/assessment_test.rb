require 'test_helper'

class AssessmentTest < ActiveSupport::TestCase
  def setup
    @school = schools(:st_teresas)
    @mal = school_subjects(:st_teresas_malayalam)
    @eng = school_subjects(:st_teresas_english)
    @assessment = assessments(:FA1_english)
    @klass = Klass.create(:level => levels(:two), :division => 'G', :school => @school)
  end
  
  test "CRUD" do
    @klass.school_subject_ids = [@mal.id, @eng.id]
    @klass.save!
    [@mal,@eng].each do |s|
      assert_not_nil @klass.assessments.select{|a|a.subject == s.subject}
    end
    assert_equal @klass.assessments.size, (@klass.assessment_groups.size * 2)
    assert_equal @klass.assessment_groups.size, @klass.assessments.for_subject(@mal.subject).size
    @klass.assessment_groups.each do |a|
      assert !a.destroyable?
    end
  end
  
  test "weightage validations" do
    a = @assessment
    at1 = a.assessment_tools.first
    at2 = a.assessment_tools.second
    at1.weightage += 10
    assert_raise ActiveRecord::RecordInvalid do
      a.update_attributes :assessment_tools_attributes => {0 => {:id => at1.id, :weightage => at1.weightage} }
      a.save!
    end
    at2.weightage -= 10
    a.update_attributes :assessment_tools_attributes => {0 => {:id => at1.id, :weightage => at1.weightage}, 1 => {:id => at2.id, :weightage => at2.weightage} }
    assert a.save!
  end
  
  test "named scopes" do
    a = assessments(:FA1_english)
    klass = a.klass
    assert klass.assessments.for_subject(subjects(:english)).include?(a)
    assert a.fa?
    assert !a.sa?
  end

  test "calculated_score_for & weighted_score_for student" do
    reading = assessment_tools(:reading_FA1_english)
    classtest = assessment_tools(:classtest_FA1_english)
    oneAstudent = Student.create(:school => @school, :klass => klasses(:one_A))
    oneAstudent.user = users(:user_without_person)
    oneAstudent.save!
    score1 = Score.create(:student => oneAstudent, :activity => activities(:reading_FA1_english1), :score => 10)
    score2 = Score.create(:student => oneAstudent, :activity => activities(:reading_FA1_english2), :score => 11)
    score3 = Score.create(:student => oneAstudent, :activity => activities(:classtest_FA1_english1), :score => 12)
    score4 = Score.create(:student => oneAstudent, :activity => activities(:classtest_FA1_english2), :score => 12)
    
    calculated_score = reading.average_score_for(oneAstudent)* reading.weightage/100 + classtest.average_score_for(oneAstudent)* classtest.weightage/100
    assert_not_nil calculated_score
    assert_equal calculated_score, @assessment.calculated_score_for(oneAstudent)
    
    ag = assessment_groups(:FA1)
    weighted_score = (calculated_score/ag.max_score) * ag.weightage
    assert_not_nil weighted_score
    assert_equal weighted_score, @assessment.weighted_score_for(oneAstudent)
    
    score3.destroy
    assert_nil @assessment.reload.calculated_score_for(oneAstudent)
    
    classtest.best_of = 1
    classtest.save!
    calculated_score = reading.average_score_for(oneAstudent)* reading.weightage/100 + classtest.average_score_for(oneAstudent)* classtest.weightage/100
    assert_not_nil calculated_score
    assert_equal calculated_score, @assessment.reload.calculated_score_for(oneAstudent)
    
    score1.destroy
    score2.destroy
    assert_nil @assessment.reload.calculated_score_for(oneAstudent)
  end
  
end
