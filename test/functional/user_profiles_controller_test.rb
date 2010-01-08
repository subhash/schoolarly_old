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
    @paru=users(:paru)
    @shenu=users(:shenu)
    @admitted_student = students(:admitted_with_profile)
    @enrolled_student = students(:enrolled_with_profile)
    @bsc_statistics=qualifications(:bsc_statistics)
    @err=qualifications(:err_msc_statistics)
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
    assert_select 'table.ui-state-default', :count => 3
  end
  
  test "teacher profile should show breadcrumbs with school name, teacher name, Profile & 1 action" do
    UserSession.create(@antonyUser)
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
    UserSession.create(@enrolled_student.user)
    get :show, :id => @enrolled_student.user.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@enrolled_student.school), :text => @enrolled_student.school.name
    assert_select 'ul#breadcrumbs li a[href=?]', klass_path(@enrolled_student.current_klass), :text => @enrolled_student.current_klass.name
    assert_select 'ul#breadcrumbs li a[href=?]', student_path(@enrolled_student), :text => @enrolled_student.name
    assert_select 'ul#breadcrumbs strong', 'Profile'
    assert_select "div#action_box" do
      assert_select "div.button a", :count => 1
      assert_select "div.button a[href=?]" , edit_user_profile_path(@enrolled_student.user), :text => 'Edit'
    end 
    assert_select 'table.ui-state-default', :count => 3
  end
  
  test "admitted student profile should show breadcrumbs with school name, student name, Profile & 1 action" do
    UserSession.create(@admitted_student.user)
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

  test "parent profile show" do
    #TODO
  end
  
  test "should get new" do
    UserSession.create(@antonyUser)
    get :new, :id => @antonyUser.to_param
    assert_response :success
    assert_template 'user_profiles/new'
  end

  test "should create profile" do
    assert_difference('UserProfile.count',1) do
      post :create, :id => @paru,  :user_profile => {:first_name => 'first', :last_name => 'last' }
    end
    assert_redirected_to user_profile_path(@paru)
  end

  test "should get edit" do
    UserSession.create(@antonyUser)
    get :edit, :id => @antonyUser
    assert_response :success
    assert_template 'user_profiles/edit'
  end

  test "should get redirected to new if profile does not exist" do
    UserSession.create(@paru)
    get :edit, :id => @paru.to_param
    assert_redirected_to :action => 'new', :id => @paru
  end
  
  test "edit should get redirected to show if i am not the current user" do
    UserSession.create(@shenu)
    get :edit, :id => @paru.to_param
    assert_redirected_to :action => 'show', :id => @paru
  end

  test "new should get redirected to show if i am not the current user" do
    UserSession.create(@shenu)
    get :new, :id => @paru.to_param
    assert_redirected_to :action => 'show', :id => @paru
  end
  
  test "should update profile" do
    UserSession.create(@antonyUser)
    put :update, :id => @antonyUser, :user_profile => { :last_name => 'Chettan' }
    assert_redirected_to user_profile_path(@antonyUser)
  end
  
  test "teacher should add qualification thru xhr" do
    xhr :post, :add_qualification , {:id => @antonyTeacher, :qualification => @bsc_statistics}
    assert_response :success
    assert_template "user_profiles/qualification_create_success"
  end

  test "teacher should show error in add qualification thru xhr" do
    xhr :post, :add_qualification , {:id => @sunil, :qualification => @err}
    assert_response :success
    assert_template "user_profiles/qualification_create_error"
  end
  
end
