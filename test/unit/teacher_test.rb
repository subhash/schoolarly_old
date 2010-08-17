require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:user_without_person)
    @stteresas = schools(:st_teresas)
    @teacher = teachers(:rose)
    @level = levels(:three)
    @mal = school_subjects(:st_teresas_malayalam) 
    @eng = school_subjects(:st_teresas_english)
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

  test "A teacher can own more than 1 klasss" do
    assert_difference('@teacher.reload.owned_klasses.size', 2) do
      three_c = Klass.create(:level => @level, :division => 'C', :school => @stteresas, :class_teacher => @teacher)
      three_d = Klass.create(:level => @level, :division => 'D', :school => @stteresas, :class_teacher => @teacher)
    end
  end
  
  test "teacher has many papers & teacher has many klasses through papers" do
    three_c = Klass.create(:level => @level, :division => 'C', :school => @stteresas, :class_teacher => @teacher)
    three_d = Klass.create(:level => @level, :division => 'D', :school => @stteresas, :class_teacher => @teacher)
    assert_difference('@teacher.reload.klasses.size', 2) do
      assert_difference('@teacher.reload.papers.size', 3) do
        paper1 = Paper.create(:klass => three_c, :school_subject  => @mal, :teacher => @teacher)
        paper2 = Paper.create(:klass => three_c, :school_subject  => @eng, :teacher => @teacher)
        paper3 = Paper.create(:klass => three_d, :school_subject  => @mal, :teacher => @teacher)
      end      
    end
  end
  
end
