require 'test_helper'


class KlassTest < ActiveSupport::TestCase

  def setup
    @oneA = klasses :one_A
    @twoB = klasses :two_B
    @sunil = teachers :sunil
    @stTheresas = schools :st_teresas
  end
  
  test "klass-crud" do
    three_c = Klass.new(:level => 3, :division =>'C', :year =>2009)
    three_c.school = @stTheresas
    three_c.save!
    assert_equal 3, @stTheresas.klasses.in_year(2009).size
    three_c.destroy
    assert_equal 2, @stTheresas.klasses.in_year(2009).size
    assert_equal 3, @stTheresas.klasses.size
  end
  
  test "klass-can-be-destroyed" do
    three_c = Klass.new(:level => 3, :division =>'C', :year =>2009)
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
    assert_equal 1, @oneA.current_students.size
    shenu = students(:shenu)    
    assert_equal @oneA, shenu.current_enrollment.klass
    assert_equal @oneA, shenu.current_klass    
  end
  
  test "historical klass membership" do    
    assert_equal 1, @twoB.students.size
    assert_equal 0, @twoB.current_students.size
  end
  
end
