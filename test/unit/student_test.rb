require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_without_person)
    @stteresas = schools(:st_teresas)
    @mary = students(:mary)
    @oneAstudent = students(:oneA_student)
    @student = students(:student_not_enrolled)
    @mal = school_subjects(:st_teresas_malayalam) 
    @eng = school_subjects(:st_teresas_english)
    @three_c = Klass.create(:level => levels(:three), :division =>'C', :school => @stteresas)
    @klass = klasses(:one_A)
    @reading_FA1_english1 = activities(:reading_FA1_english1)
    @reading_FA1_english2 = activities(:reading_FA1_english2)
    @classtest_FA1_english1 = activities(:classtest_FA1_english1)
    @classtest_FA1_english2 = activities(:classtest_FA1_english2)
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
  
  test "named_scope - not_enrolled" do
    student = Student.new(:school => @stteresas)
    assert_difference('@stteresas.students.not_enrolled.size', 0) do
      assert_difference('@stteresas.students.not_enrolled.size', 1) do
        student.save! 
      end
      @three_c.students << student
    end
  end
  
#  test "has many scores" do
#    assert_difference('@oneAstudent.reload.scores.size', 3) do
#      assert_difference('@oneAstudent.reload.scores.for_activities([@reading_FA1_english1.id, @reading_FA1_english2.id]).size', 2) do
#        score1 = Score.create(:student => @oneAstudent, :activity => @reading_FA1_english1, :score => 10)
#        score2 = Score.create(:student => @oneAstudent, :activity => @reading_FA1_english2, :score => 11)
#        score3 = Score.create(:student => @oneAstudent, :activity => @classtest_FA1_english1, :score => 12)
#      end
#    end
#  end
  
  test "has many activities through scores" do
    
  end
  
end
