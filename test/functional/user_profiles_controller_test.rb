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
    @student_without_school=users(:student_without_school)
    @admitted_student = students(:admitted_with_profile)
    @enrolled_student = students(:enrolled_with_profile)
    @bsc_statistics=qualifications(:bsc_statistics)
    @err=qualifications(:err_msc_statistics)
    @treasa=users(:treasa)
    UserSession.create(@stTeresasSchool.user)
  end

  test "school profile should show breadcrumbs with school name, Profile" do
    get :show, :id => @stTeresasAdmin.to_param
    assert_response :success
    assert_template 'user_profiles/show'
    assert_breadcrumb(@stTeresasSchool.name, :url => school_path(@stTeresasSchool), :index => 1)
    assert_breadcrumb('Profile', :current => true)
    assert_breadcrumb_count(2)
    assert_action_count(1)
    assert_action('Edit', :url => edit_user_profile_path(@stTeresasSchool.user), :index => 1)
    assert_select 'table.ui-state-default', :count => 3
  end
  
  test "school should not show Edit action if it is not the current user" do
    get :show, :id => @stTeresasAdmin.to_param
    assert_response :success
    assert_template 'user_profiles/show'
    assert_action_count(0)
  end
  
  test "teacher profile should show breadcrumbs with school name, teacher name, Profile & 1 action" do
    UserSession.create(@antonyUser)
    get :show, :id => @antonyUser.to_param
    assert_response :success
    assert_template 'user_profiles/show'
    assert_breadcrumb(@stAntonys.name, :url => school_path(@stAntonys), :index => 1)
    assert_breadcrumb(@antonyTeacher.name, :url => teacher_path(@antonyTeacher), :index => 2)
    assert_breadcrumb('Profile', :current => true)
    assert_breadcrumb_count(3)
    assert_action_count(1)
    assert_action('Edit', :url => edit_user_profile_path(@antonyUser), :index => 1)
    assert_select 'table.ui-state-default', :count =>3
  end
  
  test "teacher should not show Edit action if it is not the current user" do
    get :show, :id => @antonyUser.to_param
    assert_response :success
    assert_template 'user_profiles/show'
    assert_action_count(0)
  end
  
  test "enrolled student profile should show breadcrumbs with school name, klass name, student name, Profile & 1 action" do
    UserSession.create(@enrolled_student.user)
    get :show, :id => @enrolled_student.user.to_param
    assert_response :success
    assert_template 'user_profiles/show'
    assert_breadcrumb(@enrolled_student.school.name, :url => school_path(@enrolled_student.school), :index => 1)
    assert_breadcrumb(@enrolled_student.current_klass.name, :url => klass_path(@enrolled_student.current_klass), :index => 2)
    assert_breadcrumb(@enrolled_student.name, :url => student_path(@enrolled_student), :index => 3)
    assert_breadcrumb('Profile', :current => true)
    assert_breadcrumb_count(4)
    assert_action_count(1)
    assert_action('Edit', :url => edit_user_profile_path(@enrolled_student.user), :index => 1)
    assert_select 'table.ui-state-default', :count => 3
  end
  
  test "enrolled student should not show Edit action if it is not the current user" do
    get :show, :id => @enrolled_student.user.to_param
    assert_response :success
    assert_template 'user_profiles/show'
    assert_action_count(0)
  end  
  
  test "admitted student profile should show breadcrumbs with school name, student name, Profile & 1 action" do
    UserSession.create(@admitted_student.user)
    get :show, :id => @admitted_student.user.to_param
    assert_response :success
    assert_template 'user_profiles/show'
    assert_breadcrumb(@admitted_student.school.name, :url => school_path(@admitted_student.school), :index => 1)
    assert_breadcrumb(@admitted_student.name, :url => student_path(@admitted_student), :index => 2)
    assert_breadcrumb('Profile', :current => true)
    assert_breadcrumb_count(3)
    assert_action_count(1)
    assert_action('Edit', :url => edit_user_profile_path(@admitted_student.user), :index => 1)
    assert_select 'table.ui-state-default', :count => 3
  end

  test "admitted student should not show Edit action if it is not the current user" do
    get :show, :id => @admitted_student.user.to_param
    assert_response :success
    assert_template 'user_profiles/show'
    assert_action_count(0)
  end
  
  test "user who does not belong to any school should show breadcrumb as user name, Profile & 1 action" do
    UserSession.create(@student_without_school)
    get :show, :id => @student_without_school.to_param
    assert_response :success
    assert_template 'user_profiles/show'
    assert_breadcrumb(@student_without_school.person.name, :url => student_path(@student_without_school.person), :index => 1)
    assert_breadcrumb('Profile')
    assert_breadcrumb_count(2)
    assert_action_count(1)
    assert_action('Edit', :url => edit_user_profile_path(@student_without_school), :index => 1)
    assert_select 'table.ui-state-default', :count => 3
  end

  test "parent profile show" do
    #TODO
  end
  
  test "new should be redirected to edit if profile already exists" do
    UserSession.create(@admitted_student.user)
    get :new, :id => @admitted_student.user.to_param
    assert_redirected_to :action => 'edit', :id => @admitted_student.user
  end

  test "should get new" do
    UserSession.create(@paru)
    get :new, :id => @paru.to_param
    assert_response :success
    assert_template 'user_profiles/new'
  end
  
  test "should create profile" do
    assert_nil @paru.user_profile
    assert_equal @paru.email, @paru.person.name
    assert_difference('UserProfile.count',1) do
      post :create, :id => @paru,  :user_profile => {:city=>nil, :phone_mobile=>nil, :pincode=>nil, :country=>nil, :phone_landline=>nil, :address_line_1=>nil, :address_line_2=>nil, :first_name=>'first', :last_name=>'last', :state=>nil, :middle_name=>nil}
    end
    assert_not_nil assigns(:user_profile)
    assert_equal 'paru@schoolarly.com',  assigns(:user_profile).user.email
    assert_equal 'first last',  assigns(:user_profile).user.person.name.to_s
    assert_equal "Profile was successfully created." , flash[:notice]
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
  
  test "should show without Edit action if i am not the current user" do
    UserSession.create(@shenu)
    get :show, :id => @paru.to_param
    assert_response :success
    assert_template 'user_profiles/show'
    assert_action_count(0)
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
    assert_difference('UserProfile.count',0) do
      put :update, :id => @antonyUser, :user_profile => { :last_name => 'Chettan' }
    end
    assert_equal 'Antony Chettan',  assigns(:user_profile).user.person.name.to_s
    assert_redirected_to user_profile_path(@antonyUser)
  end
  
  test "exception handler handles exceptions" do
    UserSession.create(@treasa)
    session[:parent_url] = edit_user_profile_path(@treasa)
    assert_difference('UserProfile.count',0) do
      put :create, :id => @treasa, :user_profile => { :last_name => 'ChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechyChechy' }
    end
    assert_equal "Error Occurred:", flash[:notice].slice(0,15)
    assert_redirected_to edit_user_profile_path(@treasa)
  end
  
  test "teacher should add qualification thru xhr" do
    xhr :post, :add_qualification , {:id => @antonyTeacher, :qualification => @bsc_statistics}
    assert_response :success
    assert_template 'user_profiles/qualification_create_success'
  end

  test "teacher should show error in add qualification thru xhr" do
    xhr :post, :add_qualification , {:id => @sunil, :qualification => @err}
    assert_response :success
    assert_template 'user_profiles/qualification_create_error'
  end
  
end
