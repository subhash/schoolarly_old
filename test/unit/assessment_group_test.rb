require 'test_helper'

class AssessmentGroupTest < ActiveSupport::TestCase

  def setup
    @one_A = klasses(:one_A)
    @level = levels(:one)
    @st_teresas = schools(:st_teresas)
  end
  
  test "CRUD" do
    three_c = Klass.create(:level => @level, :division => 'C', :school => @st_teresas)
    assert_equal AssessmentType.count, three_c.assessment_groups.size   
    three_c.assessment_groups.each do |ag|
      assert_not_nil ag.assessment_type
      assert ag.valid?
    end
    three_c.destroy
    assert_equal [], AssessmentGroup.find(:all , :conditions =>{:klass_id => three_c.id, :academic_year_id => three_c.academic_year.id})
  end
  
  test "validations" do
    three_c = Klass.create(:level => @level, :division => 'C', :school => @st_teresas)  
    three_c.assessment_groups.each do |ag|
      at = ag.assessment_type
      agroup = AssessmentGroup.new(:assessment_type => at, :academic_year => ag.academic_year,:weightage => at.weightage, :max_score => at.max_score, :klass => three_c)
      assert !agroup.valid?
      agroup = AssessmentGroup.new(:assessment_type => at, :academic_year => academic_years(:st_teresas_year_old), :weightage => at.weightage, :max_score => at.max_score, :klass => three_c)
      assert agroup.valid?
    end
  end
  
  test "named scopes" do
    three_c = Klass.create(:level => @level, :division => 'C', :school => @st_teresas)
    assert_equal three_c.assessment_groups.size, (three_c.assessment_groups.SA.size + three_c.assessment_groups.FA.size)
  end
end
