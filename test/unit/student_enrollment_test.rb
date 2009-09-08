require 'test_helper'

class StudentEnrollmentTest < ActiveSupport::TestCase
  def setup
    @shenu = students :shenu
    @klass = klasses(:two_B)
    @shenu_enr = student_enrollments :shenu_one
    @mal = subjects(:malayalam)
    @eng = subjects(:english)
  end
  
  test "student-enrollment relationship" do
    @shenu_enr.klass = @klass
    @shenu_enr.student = @shenu
    @shenu.current_enrollment = @shenu_enr
    @shenu.save
    assert_equal 1, @shenu.enrollments.size
  end
  
  test "student-enrollments subject relationship" do
    @shenu.current_enrollment = @shenu_enr
    assert @shenu.save
    @shenu_enr.subjects << @mal
    @shenu_enr.subjects << @eng
    assert_equal 2, @shenu.current_subjects.size
  end
  
  
end
