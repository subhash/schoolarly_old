require 'test_helper'

class AssessmentGroupTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
    @one_A = klasses(:one_A)
    @level = levels(:one)
    @st_teresas = schools(:st_teresas)
  end
  
  test "CRUD" do
    three_c = Klass.create(:level => @level, :division => 'C', :school => @st_teresas)
    assert_equal AssessmentType.count, three_c.assessment_groups.size   
    three_c.assessment_groups.each do |ag|
      at = ag.assessment_type
      assert_not_nil at
      assert ag.valid?
      agroup = AssessmentGroup.new(:assessment_type => at, :academic_year => ag.academic_year,:weightage => at.weightage, :max_score => at.max_score, :klass => three_c)
      assert !agroup.valid?
    end
  end
end
