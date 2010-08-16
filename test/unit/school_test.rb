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
    klass1 = Klass.new(:level => levels(:one), :division => "F")
    klass2 = Klass.new(:level => levels(:two), :division => "G")
    assert_difference('@school.klasses.size', 2) do
      @school.klasses << klass1
      @school.klasses << klass2
      @school.save
    end
    assert_difference('@school.klasses.size', -1) do
      klass1.destroy
    end
  end
  
  test "school can have many teachers" do
    
  end
  
  test "school can have many subjects" do
    
  end
  
  # academic year done in academic_year_test
  
  test "school-students association" do
    
  end
  
  # assessment tool names in assessment_tool_name_test
end
