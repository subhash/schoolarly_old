require 'test_helper'

class AssessmentToolTest < ActiveSupport::TestCase
  def setup
    @school=schools(:st_teresas)
    @eng=school_subjects(:st_teresas_english)  
    @klass = klasses(:one_A)
  end
  
  test "CRUD" do
    @klass.papers << Paper.create(:school_subject => @eng)
    assert_equal 6, @klass.reload.assessments.size
    @klass.assessments.each do |a|
      assert_difference 'a.reload.assessment_tools.size' do
        tool = AssessmentTool.create(:assessment => a, :name => "Reading", :weightage => 100, :best_of => 1)
      end
    end
    @klass.assessments.each do |a|
      assert_difference 'a.reload.assessment_tools.size', -1 do
        a.assessment_tools.first.destroy
      end
    end
  end
  
  test "validations" do
    at = assessment_tools(:reading_FA1_english)
    at.weightage = 110
    assert_raise ActiveRecord::RecordInvalid do
      at.save!
    end    
  end
  
end
