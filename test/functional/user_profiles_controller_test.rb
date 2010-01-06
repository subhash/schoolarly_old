require 'test_helper'
require 'authlogic/test_case'

class UserProfilesControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @verbosity = $-v
    $-v = nil
    @stTeresasSchool=schools(:st_teresas)
    @stTeresasProfile=user_profiles(:stTeresas)
    @stTeresasAdmin=users(:admin_st_teresas)
    @stAntonys=schools(:st_antonys)
    @antonyTeacher=teachers(:teacher_antony)
    @antonyUser=users(:teacher_antony)
    @antonyProfile=user_profiles(:teacher_antony)
    @one_A=klasses(:one_A)
    @paru=users(:paru)
    @admitted_student = students(:paru)
    @enrolled_student = students(:shenu)
    UserSession.create(@stTeresasSchool.user)
  end
  
  def shutdown
    $-v = @verbosity
  end
 
  test "school profile should show breadcrumbs with school name, Profile" do
    get :show, :id => @stTeresasAdmin.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@stTeresasSchool), :text => @stTeresasSchool.name
    assert_select 'ul#breadcrumbs strong', 'Profile'
    assert_select "div#action_box" do
      assert_select "div.button a", :count => 1
      assert_select "div.button a[href=?]" , edit_user_profile_path(@stTeresasSchool.user), :text => 'Edit'
    end 
    assert_select 'table.ui-state-default', :count => 3
  end
  
  test "teacher profile should show breadcrumbs with school name, teacher name, Profile & 1 action" do
    get :show, :id => @antonyUser.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@stAntonys), :text => @stAntonys.name
    assert_select 'ul#breadcrumbs li a[href=?]', teacher_path(@antonyTeacher), :text => @antonyTeacher.name
    assert_select 'ul#breadcrumbs strong', 'Profile'
    assert_select "div#action_box" do
      assert_select "div.button a", :count => 1
      assert_select "div.button a[href=?]" , edit_user_profile_path(@antonyUser), :text => 'Edit'
    end 
    assert_select 'table.ui-state-default', :count =>3
  end
  
  test "enrolled student profile should show breadcrumbs with school name, klass name, student name, Profile & 1 action" do
    get :show, :id => @enrolled_student.user.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@enrolled_student.school), :text => @enrolled_student.school.name
    assert_select 'ul#breadcrumbs li a[href=?]', klass_path(@one_A), :text => @one_A.name
    assert_select 'ul#breadcrumbs li a[href=?]', student_path(@enrolled_student), :text => @enrolled_student.name
    assert_select 'ul#breadcrumbs strong', 'Profile'
    assert_select "div#action_box" do
      assert_select "div.button a", :count => 1
      assert_select "div.button a[href=?]" , edit_user_profile_path(@enrolled_student.user), :text => 'Edit'
    end 
    assert_select 'table.ui-state-default', :count => 3
  end
  
  test "admitted student profile should show breadcrumbs with school name, student name, Profile & 1 action" do
    get :show, :id => @admitted_student.user.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@admitted_student.school), :text => @admitted_student.school.name
    assert_select 'ul#breadcrumbs li a[href=?]', student_path(@admitted_student), :text => @admitted_student.name
    assert_select 'ul#breadcrumbs strong', 'Profile'
    assert_select "div#action_box" do
      assert_select "div.button a", :count => 1
      assert_select "div.button a[href=?]" , edit_user_profile_path(@admitted_student.user), :text => 'Edit'
    end 
    assert_select 'table.ui-state-default', :count => 3
  end
  
  test "should get new" do
    get :new, :id => @antonyUser.to_param
    assert_response :success
  end

  test "should create profile" do
    assert_difference('UserProfile.count',1) do
      post :create, :id => @paru,  :user_profile => {:first_name => 'first', :last_name => 'last' }
    end
    assert_redirected_to user_profile_path(@paru)
  end

end
