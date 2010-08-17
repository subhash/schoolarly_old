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
#    assert_equal (@klass.assessment_groups.size * 2), @klass.assessments.for_year(@klass.academic_year).size
  end
end
