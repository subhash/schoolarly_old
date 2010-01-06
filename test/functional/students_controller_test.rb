require 'test_helper'

class StudentsControllerTest < ActionController::TestCase  
  
  def setup
    activate_authlogic
    @sboa = schools(:sboa)
    @student = students(:mary)
    @admitted_student = students(:paru)
    @enrolled_student = students(:shenu)
    UserSession.create(@sboa.user)
  end
  
  test "should get new" do
    get :new
    assert_response :success
    assert_template "students/new"
  end
  
  test "create student success thru xhr" do
    assert_difference('Student.count') do
      xhr :post, :create,{ :student => {:admission_number => "1" }, :user => {:email => "random@gmail.com"}, :school_id =>@sboa.id}
    end    
    assert_response :success
    assert_template "students/create_success"
  end
  
  test "create student success" do   
    assert_difference('Student.count') do
      post :create,{ :student => {}, :user => {:email => "random2@gmail.com"}}
    end 
    assert_not_nil assigns(:user)
    assert_redirected_to edit_password_reset_url(assigns(:user).perishable_token)
  end
  
  test "create student failure" do   
    assert_no_difference('Student.count') do
      post :create,{ :student => {}, :user => {:email => students(:paru).user.email}}
    end 
    assert_response :success
    assert_template "students/new"
  end
  
  test "create student failure thru xhr" do
    xhr :post, :create , {:student => {:admission_number => "1" }, :user => {:email => students(:paru).user.email}, :school_id =>@sboa.id}
    assert_response :success
    assert_template "students/create_error"
  end
  
  test "show student without school" do
    get :show, :id => @student.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs strong', @student.name
    assert_select "div#action_box" do
      assert_select "div.button a", :count => 1
      assert_select "div.button a[href=?]" , '#', :text => 'Add to school'
    end 
  end  
  
  test "show student with school without enrollment " do
    get :show, :id => @admitted_student.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@admitted_student.school), :text => @admitted_student.school.name
    assert_select 'ul#breadcrumbs strong', @admitted_student.name
    assert_select "div#action_box" do
      assert_select "div.button a", :count => 1
      assert_select "div.button a[href=?]" , "/student_enrollment/new/"+@admitted_student.id.to_s, :text => 'Assign Class'
    end 
  end
  
  test "show student with school with enrollment " do
    get :show, :id => @enrolled_student.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@enrolled_student.school), :text => @enrolled_student.school.name
    assert_select 'ul#breadcrumbs li a[href=?]', klass_path(@enrolled_student.current_enrollment.klass), :text => @enrolled_student.current_enrollment.klass.name
    assert_select 'ul#breadcrumbs strong', @enrolled_student.name
    assert_select "div#action_box" do
      assert_select "div.button a", :count => 1
      assert_select "div.button a[href=?]" , "#", :text => 'Add/Remove Subjects'
    end 
  end
  
  test "show student with subjects and exams tabs" do
  end
  
end
