require 'test_helper'


class KlassTest < ActiveSupport::TestCase
  
  def setup
    @oneA = klasses :one_A
    @twoB = klasses :two_B
    @sunil = teachers :sunil
    @stTheresas = schools :st_teresas
  end
  
  test "klass-crud" do
    three_c = Klass.new(:level => 3, :division =>'C')
    three_c.school = @stTheresas
    three_c.save!
    assert_equal 4, @stTheresas.klasses.size
    three_c.destroy
    assert_equal 3, @stTheresas.klasses.size
  end
  
  test "klass-can-be-destroyed" do
    three_c = Klass.new(:level => 3, :division =>'C')
    three_c.school = @stTheresas
    three_c.save!
    assert three_c.can_be_destroyed
    assert !@oneA.can_be_destroyed
  end
  
  test "klass-school-teacher relationship" do
    assert_equal @oneA.school, @stTheresas
    assert_equal @oneA.class_teacher, @sunil
    #assert_equal 1, @sunil.currently_owned_klasses
  end
  
  test "klass-student relationship" do
    assert_equal 2, @oneA.students.size    
    shenu = students(:shenu)    
    assert_equal @oneA, shenu.klass    
  end
  
#  test "historical klass membership" do    
#    assert_equal 1, @twoB.students.size
#    assert_equal 0, @twoB.current_students.size
#  end
  
  test "teacher_allotments" do
    #    TODO
  end
  
  test "current_academic_year" do
    #  TODO
  end
  
end
