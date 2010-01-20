require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  def setup
    @school = schools(:st_teresas)
    @user = users(:mary)
    @paru = students(:paru)
  end
  
  test "student-user association" do
    student = Student.new
    student.user = @user
    student.school = @school
    assert student.save
    assert_equal @user.person, student        
  end  
  
  test "student-school association" do 
    assert_equal @paru.school, @school
    assert_equal 3, @school. students.size
    @school.students.delete(@paru)
    @school.save!
    # TODO revisit the reload - why doesnt it work otherwise?
    @paru.reload
    assert_nil @paru.school
    assert_equal 2, @school.students.size
  end
end
