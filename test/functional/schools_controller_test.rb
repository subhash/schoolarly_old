require 'test_helper'
require 'authlogic/test_case'

class SchoolsControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @sboa = schools(:sboa)
    @stAntonys=schools(:st_antonys)
    @stTeresas=schools(:st_teresas)
    @current_year=Klass.current_academic_year(@stAntonys)
    @six_D_without_eg=klasses(:six_D_without_eg).id.to_s + '_content_table'
    @six_E_with_egs=klasses(:six_E_with_egs).id.to_s + '_content_table'
    UserSession.create(@sboa.user)
  end
  
  test "login" do
    #    TODO
  end
  
  test "redirect_if_not_logged_in" do
    # TODO
  end
  
  test "school should show breadcrumb with school name and 4 actions" do
    get :show, :id => @sboa.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs strong', @sboa.name
    assert_select "div#action_box" do
      assert_select "a", :count => 4
      assert_select "a[href=?]" , edit_user_profile_path(@sboa.user), :text => 'Edit Profile'
      assert_select "a[href=?]" , '#', :text => 'Add class'
      assert_select "a[href=?]" , '#', :text => 'Invite Student'
      assert_select "a[href=?]" , '#', :text => 'Invite Teacher'
    end 
  end
  
  test "school should show all Class, Students, Teachers, Exams tabs" do
    get :show, :id => @stAntonys.to_param
    assert_response :success
    assert_select 'div.tabs li', 4
    assert_select 'div#classes-tab th a', @stAntonys.klasses.in_year(@current_year).size
    assert_select 'div#students-tab .student-row', @stAntonys.students.size
    assert_select 'div#teachers-tab .teacher-row', @stAntonys.teachers.size
    assert_select 'div#exams-tab p', @stAntonys.klasses.in_year(@current_year).size
  end
  
  
  test "each klass has exam groups as table of 3 columns or a table of single column with a no exam group info" do
    get :show, :id => @stAntonys.to_param
    assert_response :success
    assert_select "div#accordion table#" + @six_D_without_eg + " tr td", :text => 'No exam group added yet'
    assert_select "div#accordion table#" + @six_E_with_egs + " tr " do
      assert_select "td", klasses(:six_E_with_egs).exams.size * 3
    end
  end
  
  
end
