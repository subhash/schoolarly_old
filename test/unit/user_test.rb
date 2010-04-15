require 'test_helper'
require "authlogic/test_case"

class UserTest < ActiveSupport::TestCase
  
  def setup
    activate_authlogic
    @shenu = users(:shenu)    
  end
  
  test "shenu logs in" do    
    assert_nil controller.session["user_credentials"]
    assert UserSession.create(@shenu)
    assert_equal controller.session["user_credentials"], @shenu.persistence_token
  end
  
  test "shenu is a student" do
    assert_equal @shenu.person, students(:shenu)
    assert_equal users(:mary_kutty).person, teachers(:mary_kutty)
    assert_equal users(:sboa).person, schools(:sboa)
  end
  
#  test "shenuja is invited" do
#    @shenu = users(:shenu)    
#    assert_nil @shenu.perishable_token
#    assert @shenu.deliver_invitation!
#    assert_not_nil @shenu.perishable_token
#  end
  
end
