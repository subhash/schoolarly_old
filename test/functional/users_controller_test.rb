require 'test_helper'
require 'authlogic/test_case'

class UsersControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
  end
  
  test "shenuja logs in" do
    assert UserSession.create(users(:shenu))
  end
  
end
