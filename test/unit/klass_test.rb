require 'test_helper'

class KlassTest < ActiveSupport::TestCase
  def setup
    @klass = klasses(:one_A)
    @teacher = teachers(:sunil)
    @school = schools(:st_teresas)
  end
  
  test "klass-teacher relationship" do
    assert_equal @klass.school, @school
    assert_equal @klass.class_teacher,@teacher
  end
  
  test "klass-student relationship" do
    students = @klass.students
    assert_equal 2,students.size
    shenu = students(:shenu)    
    enrollment_one = shenu.current_enrollment
    assert_equal @klass, enrollment_one.klass
    assert_equal @klass, shenu.klass    
  end
end
