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
    assert_difference('@stTheresas.klasses.size') do 
      three_c.school = @stTheresas
      three_c.save!
    end
    assert_difference('@stTheresas.klasses.size', -1) do
      three_c.destroy
    end
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
  end
  
  test "klass-student relationship" do
    assert_equal 2, @oneA.students.size    
    shenu = students(:shenu)    
    assert_equal @oneA, shenu.klass    
  end
  
  
end
