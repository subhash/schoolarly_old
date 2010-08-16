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
      teacher1.save
      teacher2.save
    end
    assert_difference('@school.teachers.size', -1) do
      @school.teachers.delete(teacher1)
    end
  end
  
  test "school can have many subjects" do
    
  end
  
  # academic year done in academic_year_test
  
  test "school can have many students" do
    
  end
  
  # assessment tool names in assessment_tool_name_test
end
