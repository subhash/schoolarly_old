require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_without_person)
    @stteresas = schools(:st_teresas)
#    @school = schools(:st_teresas)
#    @paru = students(:paru)
#    @shenu = students :shenu
#    @klass = klasses(:two_B)
#    @mal = papers(:one_A_malayalam_sunil)
#    @eng = papers(:one_A_english_sunil)
  end 

  test "user-student association" do
    student = Student.new()
    student.user = @user
    assert student.save!
    assert_equal @user.person, student
  end

  test "student-user association" do        
    student = Student.new()
    @user.person = student
    assert @user.save!
    assert_equal student.user, @user
  end
  
  test "student belongs to school" do
    student = Student.new(:school => @stteresas)
    student.user = @user
    student.save!
    assert_equal student.school, @stteresas
    assert @stteresas.students.include?(student)
  end

#  test "student belongs to klass" do
#    assert_difference('@klass.reload.students.size', 2) do
#      @shenu.klass = @klass
#      @shenu.save!
#      @klass.students << @paru
#      @klass.save!
#    end
#    assert_difference('@klass.reload.students.size', -1) do
#      @shenu.klass = nil
#      @shenu.save!
#    end
#  end

#  
#  test "student-school association" do 
#    assert_equal @paru.school, @school
#    assert_difference('@school.students.size', -1) do 
#      @school.students.delete(@paru)
#      @school.save!
#    end
#    # TODO revisit the reload - why doesnt it work otherwise?
#    @paru.reload
#    assert_nil @paru.school
#  end
#  
#  test "student-subjects association" do
#    @one_A =  klasses(:one_A)
#    @shenu.klass = @one_A
#    assert_difference('@shenu.papers.size', 2) do
#      @shenu.papers << @eng
#      @shenu.papers << @mal
#      @shenu.save!
#    end
#    assert_difference('@shenu.reload.papers.size', -1) do
#      @one_A.papers.destroy(@eng)
#      @one_A.save!
#    end
#  end
end
