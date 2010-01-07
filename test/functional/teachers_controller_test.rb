require 'test_helper'
require 'authlogic/test_case'

class TeachersControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @sboa = schools(:sboa)
    @stTeresasSchool=schools(:st_teresas)
    @subbu = teachers(:v_subramaniam)
    @sunil=teachers(:sunil)
    @one_A = klasses(:one_A)
    @two_B = klasses(:two_B)
    @mal = subjects(:malayalam)
    @eng = subjects(:english)
    @klasses = ',' + @one_A.id.to_s + ','+ @two_B.id.to_s
    UserSession.create(@sboa.user)
  end
  
  test "teacher should show breadcrumbs with school name, teacher name/email and 2 actions" do
    get :show, :id => @subbu.to_param
    assert_response :success
    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@sboa), :text => @sboa.name
    assert_select 'ul#breadcrumbs strong', @subbu.name
    assert_select "div#action_box" do
      assert_select "div.button a", :count => 2
      assert_select "div.button a[href=?]" , edit_user_profile_path(@subbu.user), :text => 'Edit Profile'
      assert_select "div.button a[href=?]" , "/teachers/allot/" + @subbu.user.id.to_s, :text => 'Allot Subjects Classes'
    end 
  end
  
  test "add allotments should redirect to teacher show" do
    assert @sunil.current_allotments.count, 1
    post :add_allotments, :id => @sunil, :subject => @mal, :klasses => @klasses
    assert @sunil.current_allotments.count, 3
    assert_redirected_to teacher_path(@sunil)
  end
  
  test "already allotted klasses shoud appear preselected" do
    get :allot, :id => @sunil
    assert_template 'teachers/allot'
    assert_select 'td.pre-selected', :count => @sunil.current_allotments.count
    assert_select 'table#' + @eng.id.to_s + '-klasses_selectable td.selectFilter', :count => @eng.klasses.ofSchool(@stTeresasSchool).size - 1
  end
  
end
