require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:user_without_person)
    @stteresas = schools(:st_teresas)
#    @marykkutty = teachers(:marykkutty)
#    @antony = teachers(:teacher_antony)
  end
  
  test "user-teacher association" do
    teacher = Teacher.new()
    teacher.user = @user
    assert teacher.save!
    assert_equal @user.person, teacher
  end

  test "teacher-user association" do        
    teacher=Teacher.new()
    @user.person = teacher
    assert @user.save!
    assert_equal teacher.user, @user
  end
  
  test "teacher belongs to school" do
    teacher = Teacher.new(:school => @stteresas)
    teacher.user = @user
    teacher.save!
    assert_equal teacher.school, @stteresas
    assert @stteresas.teachers.include?(teacher)
  end

#  
#  test "all teachers are users" do
#    assert @marykkutty.user
#    assert teachers(:sunil).user
#    assert teachers(:v_subramaniam).user
#    assert teachers(:treasa).user
#  end
#  
#  test "teacher antony can be the class teacher of more than one class" do
#    assert_equal 4, @antony.owned_klasses.size
#  end
  
end
