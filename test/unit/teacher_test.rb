require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  def setup
    @school = schools(:st_teresas)
    @user = users(:mary)
  end
  
  test "teacher-user association" do
    teacher = Teacher.new
    teacher.user = @user
    teacher.school = @school
    assert teacher.save
    assert_equal @user.person, teacher        
  end  
  
end
