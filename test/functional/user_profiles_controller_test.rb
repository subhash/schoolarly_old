require 'test_helper'
require 'authlogic/test_case'

class UserProfilesControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @stTeresasSchool=schools(:st_teresas)
    @stTeresasProfile=user_profiles(:stTeresas)
    @stTeresasAdmin=users(:admin_st_teresas)
    @stAntonys=schools(:st_antonys)
    @antonyTeacher=teachers(:teacher_antony)
    @antonyUser=users(:teacher_antony)
    @antonyProfile=user_profiles(:teacher_antony)
    UserSession.create(@stTeresasSchool.user)
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
    assert_select 'table.ui-state-default', :count =>3
  end
  
  test "teacher profile should show breadcrumbs with school name, teacher name, Profile" do
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
  
end
