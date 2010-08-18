require 'test_helper'

class AssessmentTest < ActiveSupport::TestCase
  def setup
    @school=schools(:st_teresas)
    @mal=school_subjects(:st_teresas_malayalam)
    @eng=school_subjects(:st_teresas_english)  
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
    a = assessments(:FA1_english)
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
end
