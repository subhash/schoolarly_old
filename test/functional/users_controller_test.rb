require 'test_helper'
require 'authlogic/test_case'

class UsersControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @shenu = users(:shenu)
  end
  
#  test "shenuja logs in" do
#    assert UserSession.create(@shenu)
#  end
#  
#  test "user page should show all tabs" do
#    get :index
#    assert_tabs 3
#    assert_tab_rows 'student', Student.count
##    TODO Resolve class, id conflict in views
##    assert_tab_rows 'teacher', Teacher.count    
#    assert_action_count 4
#    assert_action 'Add Student'
#    assert_action 'Add Teacher'
#  end
  
end
