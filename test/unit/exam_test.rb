require 'test_helper'

class ExamTest < ActiveSupport::TestCase
  
  def setup
    @maths_exam = exams(:maths_half_yearly)
    @english_test = exams(:english_class_test_1)
    @halfYearly = exam_groups(:half_yearly_two_B)
    @maths = subjects(:maths)
    @english = subjects(:english)
    @twoB = klasses(:two_B)
    @oneA = klasses(:one_A)
  end
  
  test "sanity" do
    assert_equal  @maths, @maths_exam.subject
    assert_equal @english, @english_test.subject
  end
  
  test "exam group associations" do
    assert_equal @halfYearly, @maths_exam.exam_group
  end
  
  test "class associations" do
    assert_equal @twoB, @maths_exam.klass
    assert_equal @oneA, @english_test.klass 
  end
  
end
