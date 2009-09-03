require 'test_helper'

class SchoolTest < ActiveSupport::TestCase
  #fixtures :users,:schools
  
  def setup
    @user = users(:admin_st_teresas)
    @school = schools(:st_teresas)
  end
  
  test "school-user association" do    
    @school.user = @user
    assert @user.save    
  end
end
