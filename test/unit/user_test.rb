require 'test_helper'
require "authlogic/test_case"

class UserTest < ActiveSupport::TestCase
  setup :activate_authlogic
  
  test "shenu logs in" do
    shenu = users(:shenu)
    assert_nil controller.session["user_credentials"]
    assert UserSession.create(shenu)
    assert_equal controller.session["user_credentials"], shenu.persistence_token
  end
  
  test "shenu is a student" do
    shenu = users(:shenu)
    assert_equal shenu.person, students(:shenu)
    assert_equal users(:mary_kutty).person, teachers(:mary_kutty)
    assert_equal users(:sboa).person, schools(:sboa)
  end
end
