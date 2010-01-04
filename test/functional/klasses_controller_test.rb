require 'test_helper'
require 'authlogic/test_case'

class KlassesControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @stTeresas=schools(:st_teresas)
    @one_A=klasses(:one_A)
    UserSession.create(@stTeresas.user)
  end
  
  test "klass should show breadcrumb with school, klass & 2 actions" do
    get :show, :id => @one_A.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@stTeresas), :text => @stTeresas.name
    assert_select 'ul#breadcrumbs strong', @one_A.name
    assert_select "div#action_box" do
      assert_select "div.button a", :count => 2
      assert_select "div.button a[href=?]" , '#', :text => 'Add Exam Group'
      assert_select "div.button a[href=?]" , '#', :text => 'Add/Remove Subjects'
    end 
  end
  
  test "klass should show all Students, Subjects, Exams tabs" do
    get :show, :id => @one_A.to_param
    assert_response :success
    assert_select 'div.tabs li', 3
    assert_select 'div#students-tab table tr', 1 + @one_A.students.size
    assert_select 'div#subjects-tab table tr', 1 + @one_A.teachers.size
    assert_select 'div#exams-tab table', @one_A.exam_groups.size
    assert_select 'div#exams-tab table td a.ui-icon', 3 * @one_A.exams.size
  end
  
end
