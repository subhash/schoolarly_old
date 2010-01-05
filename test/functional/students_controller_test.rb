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
    #    get :new
    #    assert_response :success
    # should be changed to an rjs get
  end
  
  test "should create student" do
    assert_difference('Student.count') do
      post :create,{ :student => {:admission_number => "1" }, :user => {:email => "random@gmail.com"}, :school_id =>@sboa.id}
    end    
    assert_response :success
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
  
end
