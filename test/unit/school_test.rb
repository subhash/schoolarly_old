require 'test_helper'

class SchoolTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:admin_st_teresas)
    @school = schools(:st_teresas)
  end
  
  test "school-user association" do        
    @school.user = @user
    assert @user.save!
    assert_equal @user.person, @school
  end
  
  test "user-school association" do    
    @user.person = @school
    assert @school.save
    assert_equal @user.person, @school
  end
  
  test "school CRUD" do
    user = users(:user_without_person)
    school = School.new(:user => user)
    assert_difference ('School.count') do
      school.save
    end  
    assert_difference ('School.count', -1) do
      school.destroy
    end  
  end
  
  test "school can have many klasses" do
    klass1 = Klass.new(:level => levels(:one), :division => "F", :school => @school)
    klass2 = Klass.new(:level => levels(:two), :division => "G", :school => @school)
    assert_difference('@school.klasses.size', 2) do
      klass1.save
      klass2.save
    end
    assert_difference('@school.klasses.size', -1) do
      klass1.destroy
    end
  end
  
  test "school can have many teachers" do
    teacher1 = teachers(:no_school_teacher)
    teacher2 = teachers(:no_school_teacher2)
    teacher1.school = @school
    teacher2.school = @school
    assert_difference('@school.teachers.size', 2) do
      assert_difference('@school.teacher_users.size', 2) do
        teacher1.save
        teacher2.save
      end
    end
    assert_difference('@school.teachers.size', -1) do
      assert_difference('@school.teacher_users.size', -1) do
        @school.teachers.delete(teacher1)
        @school.save
      end
    end 
  end
  
  test "school can have many subjects" do
    school_subject1 = SchoolSubject.new(:subject => subjects(:maths), :school => @school)
    school_subject2 = SchoolSubject.new(:subject => subjects(:hindi), :school => @school)
    assert_difference('@school.school_subjects.size', 2) do
      assert_difference('@school.subjects.size', 2) do
        school_subject1.save
        school_subject2.save
      end
    end
    assert_difference('@school.school_subjects.size', -1) do
      assert_difference('@school.subjects.size', -1) do
        @school.subjects.delete(school_subject1.subject)
        @school.save
      end
    end
  end
  
  # academic year done in academic_year_test
  
  test "school can have many students" do
    student1 = students(:student_without_school)
    student2 = students(:student_without_school2)
    student1.school = @school
    student2.school = @school
    assert_difference('@school.students.size', 2) do
      assert_difference('@school.student_users.size', 2) do
        student1.save
        student2.save
      end
    end
    assert_difference('@school.students.size', -1) do
      assert_difference('@school.student_users.size', -1) do
        @school.students.delete(student1)
        @school.save
      end
    end 
  end
  
  test "school students not enrolled" do
    student1 = students(:student_not_enrolled)
    school = student1.school
    assert(school.students.not_enrolled.size > 0)
    assert_difference('school.students.not_enrolled.size', -1) do
      student1.klass = klasses(:one_A)
      student1.save
    end
  end
  
  test "school assessment_tool_names" do
    atn_1 = AssessmentToolName.new(:name => "atn_1", :school => @school)
    atn_2 = AssessmentToolName.new(:name => "atn_2", :school => @school)
    assert_difference('@school.assessment_tool_names.size', 2) do
      atn_1.save
      atn_2.save
    end
    assert_difference('@school.assessment_tool_names.size', -1) do
      atn_1.destroy
    end
  end
  
  test "school papers" do
    assert_equal(@school.klasses.collect{|k|k.papers.size}.sum, @school.papers.size)
    @klass = klasses(:klass_without_papers)
    @paper = Paper.new(:school_subject => school_subjects(:st_teresas_english))
    assert_difference('@school.unallotted_papers.size', 1) do
      assert_difference('@school.papers.size', 1) do
        @klass.papers << @paper
      end
    end
    assert_difference('@school.unallotted_papers.size', -1) do
      assert_difference('@school.papers.size', -1) do
        @paper.destroy
        @klass.save
      end
    end
  end
  
end
