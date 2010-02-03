require 'test_helper'
require 'authlogic/test_case'

class TeachersControllerTest < ActionController::TestCase
#  
#  def setup
#    activate_authlogic
#    @sboa = schools(:sboa)
#    @stTeresasSchool=schools(:st_teresas)
#    @subbu = teachers(:v_subramaniam)
#    @sunil=teachers(:sunil)
#    @one_A = klasses(:one_A)
#    @two_B = klasses(:two_B)
#    @mal = subjects(:malayalam)
#    @eng = subjects(:english)
#    @klasses = ',' + @one_A.id.to_s + ','+ @two_B.id.to_s
#    UserSession.create(@sboa.user)
#  end
#  
#  test "teacher should show breadcrumbs with school name, teacher name/email and 2 actions" do
#    UserSession.create(@subbu.user)
#    get :show, :id => @subbu.to_param
#    assert_response :success
#    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@sboa), :text => @sboa.name
#    assert_select 'ul#breadcrumbs strong', @subbu.name
#    assert_select "div#action_box" do
#      assert_select "div.button a", :count => 2
#      assert_select "div.button a[href=?]" , edit_user_profile_path(@subbu.user), :text => 'Edit Profile'
#      assert_select "div.button a[href=?]" , "/teachers/allot/" + @subbu.user.id.to_s, :text => 'Allot Subjects/Classes'
#    end
#    assert_tab_count(2)
#    assert_tab("Classes", "classes-tab")
#    assert_tab("Exams", "exams-tab")   
#  end
#  
#  test "Others should only view & not edit teacher profile. Rest of the breadcrumbs & actions should be the same" do
#    get :show, :id => @subbu.to_param
#    assert_response :success
#    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@sboa), :text => @sboa.name
#    assert_select 'ul#breadcrumbs strong', @subbu.name
#    assert_select "div#action_box" do
#      assert_select "div.button a", :count => 2
#      assert_select "div.button a[href=?]" , user_profile_path(@subbu.user), :text => 'View Profile'
#      assert_select "div.button a[href=?]" , "/teachers/allot/" + @subbu.user.id.to_s, :text => 'Allot Subjects/Classes'
#    end
#    assert_tab_count(2)
#    assert_tab("Classes", "classes-tab")
#    assert_tab("Exams", "exams-tab")   
#  end
#  
#  test "add allotments should redirect to teacher show" do
#    assert @sunil.current_allotments.count, 1
#    post :add_allotments, :id => @sunil, :subject => @mal, :klasses => @klasses
#    assert @sunil.current_allotments.count, 3
#    assert_redirected_to teacher_path(@sunil)
#  end
#  
#  test "already allotted klasses should appear preselected" do
#    get :allot, :id => @sunil
#    assert_template 'teachers/allot'
#    assert_select 'td.pre-selected', :count => @sunil.current_allotments.count
#    assert_select 'table#' + @eng.id.to_s + '-klasses_selectable td.selectFilter', :count => @eng.klasses.ofSchool(@stTeresasSchool).size - 1
#  end
#  
#  test "create teacher success thru xhr" do
#    assert_difference('Teacher.count') do
#      xhr :post, :create,{ :user => {:email => "sboateacher@gmail.com"}, :school_id =>@sboa.id }
#    end    
#    assert_response :success
#    assert_template "teachers/create_success"
#  end
#  
#  test "create teacher success" do   
#    assert_difference('Teacher.count') do
#      post :create,{ :user => {:email => "teacher@gmail.com"}}
#    end 
#    assert_not_nil assigns(:user)
#    assert_redirected_to edit_password_reset_url(assigns(:user).perishable_token)
#  end
#  
#  test "create teacher failure" do   
#    assert_no_difference('Student.count') do
#      post :create,{:user => {:email => @sunil.user.email}}
#    end 
#    assert_response :success
#    assert_template "teachers/new"
#  end
#  
#  test "create teacher failure thru xhr" do
#    xhr :post, :create , {:user => {:email => @sunil.user.email}, :school_id =>@sboa.id}
#    assert_response :success
#    assert_template "teachers/create_error"
#  end
end
