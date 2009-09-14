require 'test_helper'

class KlassTest < ActiveSupport::TestCase
  def setup
    @oneA = klasses :one_A
    @twoB = klasses :two_B
    @sunil = teachers :sunil
    @stTheresas = schools :st_teresas
  end
  
  test "klass-teacher relationship" do
    assert_equal @oneA.school, @stTheresas
    assert_equal @oneA.class_teacher, @sunil
  end
  
  test "klass-student relationship" do
    assert_equal 2, @oneA.students.size    
    assert_equal 2, @oneA.current_students.size
    shenu = students(:shenu)    
    assert_equal @oneA, shenu.current_enrollment.klass
    assert_equal @oneA, shenu.current_klass    
  end
  
  test "historical klass membership" do    
    assert_equal 1, @twoB.students.size
    assert_equal 0, @twoB.current_students.size
  end
end
