require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  def setup
    @school = schools(:st_teresas)
    @user = users(:mary)
  end
  
  test "student-user association" do
    student = Student.new
    student.user = @user
    student.school = @school
    assert student.save
    assert_equal @user.person, student        
  end  
end
