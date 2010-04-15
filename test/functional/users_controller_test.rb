require 'test_helper'
require 'authlogic/test_case'

class UsersControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @shenu = users(:shenu)
  end
  
  test "shenuja logs in" do
    assert_nil session["user_credentials"]
    assert UserSession.create(@shenu)
    assert_equal session["user_credentials"], @shenu.persistence_token
  end

  
  test "tabs and actions" do
    get :index
    assert_tabs do |t|
      t.assert_schools_tab 
      t.assert_students_tab 2
      t.assert_teachers_tab 3
    end
    assert_action_count 4
    assert_action 'Add Student', :url => '#'
    assert_action 'Add Teacher', :url => '#'
  end
  
end
