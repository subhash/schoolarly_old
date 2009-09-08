require 'test_helper'

class StudentEnrollmentTest < ActiveSupport::TestCase
  def setup
    @student = students(:shenu)
    @klass = klasses(:two_B)
  end
  
#  test "student-enrollment relationship" do
#    enr_1 = student_enrollments(:enrollment_paru)
#    enr_2 = student_enrollments(:enrollment_paru_current)
#    enr_1.klass = @klass
#    enr_2.klass = @klass
#    enr_1.student = @student
#    enr_2.student = @student
#    @student.current_enrollment = enr_1
#    @student.save
#    assert_equal 2, @student.enrollments
#  end
end
