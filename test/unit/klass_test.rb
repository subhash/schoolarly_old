require 'test_helper'

class KlassTest < ActiveSupport::TestCase
  
  def setup
    @sunil = teachers :sunil
    @stteresas = schools(:st_teresas)
    @level = levels(:three)
    @klass_with_students = klasses(:klass_with_students)
    @klass_with_papers = klasses(:klass_with_papers)
    @student = students(:student1_for_klass_with_students)
  end
  
  test "klass-crud" do
    three_c = Klass.new(:level => @level, :division => 'C')
    assert_difference('@stteresas.klasses.size', 1) do 
      three_c.school = @stteresas
      three_c.save!
    end
    assert_difference('@stteresas.klasses.size', -1) do
      three_c.destroy
    end
  end
  
  test "klass can be destroyed" do
    three_c = Klass.new(:level => @level, :division =>'C')
    three_c.school = @stteresas
    three_c.save!
    assert three_c.can_be_destroyed
    assert !@klass_with_students.can_be_destroyed
    assert !@klass_with_papers.can_be_destroyed
  end
  
  test "klass-school-teacher relationship" do
    three_c = Klass.create(:level => @level, :division =>'C', :school => @stteresas, :teacher_id => @sunil.id)
    assert_equal three_c.school, @stteresas
    assert @stteresas.klasses.include?(three_c)
    assert_equal three_c.class_teacher, @sunil
    assert @sunil.owned_klasses.include?(three_c)
  end
  
  test "klass-student relationship" do
    assert_equal 2, @klass_with_students.students.size    
    assert_equal @klass_with_students, @student.klass    
  end
  
end
