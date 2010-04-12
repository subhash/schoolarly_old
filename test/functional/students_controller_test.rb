require 'test_helper'
require 'authlogic/test_case'

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
#    assert_difference('Student.count') do
#      xhr :post, :create,{ :student => {:admission_number => "1" }, :user => {:email => "random@gmail.com"}, :school_id =>@sboa.id}
#    end    
#    assert_response :success
#    assert_template "students/create_success"
  end
  
  test "create student success" do   
#    assert_difference('Student.count') do
#      post :create,{ :student => {}, :user => {:email => "random2@gmail.com"}}
#    end 
#    assert_not_nil assigns(:user)
#    assert_redirected_to edit_password_reset_url(assigns(:user).perishable_token)
  end
  
  test "create student failure" do   
#    assert_no_difference('Student.count') do
#      post :create,{ :student => {}, :user => {:email => students(:paru).user.email}}
#    end 
#    assert_response :success
#    assert_template "students/new"
  end
  
  test "create student failure thru xhr" do
#    xhr :post, :create , {:student => {:admission_number => "111222333" }, :user => {:email => students(:paru).user.email}, :school_id =>@sboa.id}
#    assert_response :success
#    assert_template "students/create_error"
  end
  
  test "show student without school" do
#    get :show, :id => @student.to_param
#    assert_response :success    
#    assert_breadcrumb (@student.name)
#    assert_select "div#action_box" do
#      assert_select "div.button a", :count => 2
#      assert_select "div.button a[href=?]" , '#', :text => 'Add to school'
#    end 
  end  
  
  test "show student with school without enrollment " do
#    get :show, :id => @admitted_student.to_param
#    assert_response :success
#    assert_breadcrumb(@admitted_student.school.name, school_path(@admitted_student.school), 1)   
#    assert_breadcrumb(@admitted_student.name)
#    assert_select "div#action_box" do
#      assert_select "div.button a", :count => 2
#      assert_select "div.button a[href=?]" , "#", :text => 'Assign Class'
#    end 
  end
  
  test "show student with school with enrollment " do
#    get :show, :id => @enrolled_student.to_param
#    assert_response :success
#    assert_breadcrumb(@enrolled_student.school.name, school_path(@enrolled_student.school),1)
#    assert_breadcrumb(@enrolled_student.current_enrollment.klass.name, klass_path(@enrolled_student.current_enrollment.klass), 2)
#    assert_breadcrumb(@enrolled_student.name)
#    assert_select "div#action_box" do
#      assert_select "div.button a", :count => 2
#      assert_select "div.button a[href=?]" , "#", :text => 'Add/Remove Subjects'
#    end 
  end
  
  test "show student with subjects and exams tabs" do
#    get :show, :id => @enrolled_student.to_param
#    assert_tab_count(2)
#    assert_tab("Subjects", "subjects-tab")
#    assert_tab("Exams/Scores", "exams-tab")   
#    assert_select '#subjects-tab tr[id*=subject-]', @enrolled_student.current_enrollment.subjects.size    
  end
  
end
