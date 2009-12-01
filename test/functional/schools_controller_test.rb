require 'test_helper'
require 'authlogic/test_case'

class SchoolsControllerTest < ActionController::TestCase
  def setup
    activate_authlogic
    @sboa = schools(:sboa)
    UserSession.create(@sboa.user)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:schools)
  end
  
  test "show school should show breadcrumbs, actions" do
    get :show, :id => @sboa.to_param
    assert_response :success
    assert_select 'div#breadcrumbs strong', @sboa.name
    assert_select 'div#action_box a[href=?]', edit_user_profile_path(@sboa.user), 'Edit Profile'
    assert_select 'div#action_box a', 'Invite Student'  
    assert_select 'div#action_box a', 'Invite Teacher'
  end
  
  test "school should show all students, teachers and classes" do
    get :show, :id => @sboa.to_param
    assert_response :success
    assert_select 'div.tabs li', 3
    assert_select 'div#teachers-tab .teacher-row', @sboa.teachers.size
    assert_select 'div#students-tab .student-row', @sboa.students.size
    # TODO test Classes tab
  end
  
  
  #  test "should get new" do
  #    get :new
  #    assert_response :success
  #  end
  #
  #  test "should create school" do
  #    assert_difference('School.count') do
  #      post :create, :school => { }
  #    end
  #
  #    assert_redirected_to school_path(assigns(:school))
  #  end
  #
  #
  #  test "should get edit" do
  #    get :edit, :id => schools(:sboa).to_param
  #    assert_response :success
  #  end
  #
  #  test "should update school" do
  #    put :update, :id => schools(:sboa).to_param, :school => { }
  #    assert_redirected_to school_path(assigns(:school))
  #  end
  #
  #  test "should destroy school" do
  #    assert_difference('School.count', -1) do
  #      delete :destroy, :id => schools(:sboa).to_param
  #    end
  #
  #    assert_redirected_to schools_path
  #  end
end
