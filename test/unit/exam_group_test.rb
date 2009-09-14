require 'test_helper'

class ExamGroupTest < ActiveSupport::TestCase
  
  def setup
    @examGroup = exam_groups(:half_yearly_two_B)
    @klass = klasses(:two_B)
  end
  
  test "sanity" do
    assert_equal @klass, @examGroup.klass
  end
  
  test "containing exams" do
    assert_equal 2,  @examGroup.exams.size
  end
  
end
