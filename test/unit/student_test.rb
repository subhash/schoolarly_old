require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_without_person)
    @stteresas = schools(:st_teresas)
    @mary = students(:mary)
    @student = students(:student_not_enrolled)
    @mal = school_subjects(:st_teresas_malayalam) 
    @eng = school_subjects(:st_teresas_english)
    @three_c = Klass.create(:level => levels(:three), :division =>'C', :school => @stteresas)
#    @paru = students(:paru)
#    @shenu = students :shenu
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
    assert_difference('@stteresas.students.size', -1) do 
      @stteresas.students.delete(student)
      @stteresas.save!
    end
    assert_nil student.reload.school
  end

  test "student belongs to klass" do
    assert_difference('@three_c.reload.students.size', 1) do
      @student.klass = @three_c
      @student.save!
    end
    @three_c.students << @mary
    assert_equal @three_c, @mary.klass
    assert_difference('@three_c.students.size', -1) do 
      @three_c.students.delete(@student)
      @three_c.save!
    end
    assert_nil @student.reload.klass
  end

  test "student has many papers & student has many subjects through papers" do
    @student.klass = @three_c
    @student.save!
    assert_difference('@student.reload.subjects.size', 2) do
      assert_difference('@student.reload.papers.size', 2) do
        paper1 = Paper.create(:klass => @three_c, :school_subject  => @mal)
        paper2 = Paper.create(:klass => @three_c, :school_subject  => @eng)
        paper1.students << @student
        paper2.students << @student
      end      
    end
  end
  
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
