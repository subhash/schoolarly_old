require 'test_helper'
require 'authlogic/test_case'

class TeachersControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @sboa = schools(:sboa)
    @subbu=teachers(:v_subramaniam)
    UserSession.create(@sboa.user)
  end
  
  test "teacher should show breadcrumb with school name, teacher name/email and 2 actions" do
    get :show, :id => @subbu.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@sboa), :text => @sboa.name
    assert_select 'ul#breadcrumbs strong', @subbu.name
    assert_select "div#action_box" do
      assert_select "div.button a", :count => 2
      assert_select "div.button a[href=?]" , edit_user_profile_path(@subbu.user), :text => 'Edit Profile'
      assert_select "div.button a[href=?]" , "/teachers/allot/" + @subbu.user.id.to_s, :text => 'Allot Subjects Classes'
    end 
  end
  
end
