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
    #@sunil_physics = teacher_subject_allotments(:sunil_physics)
    UserSession.create(@sboa.user)
  end
  
  test "teacher should show breadcrumbs with school name, teacher name/email and 2 actions" do
    UserSession.create(@subbu.user)
    get :show, :id => @subbu.to_param
    assert_response :success
    assert_select 'div#breadcrumbs ul#crumbs li a[href=?]', school_path(@sboa), :text => @sboa.name
    assert_select 'div#breadcrumbs ul#crumbs li a[href=?]', "", :text => @subbu.name
    assert_select "ul#right-bar" do
      assert_select "li a", :count => 3
      assert_select "li a[href=?]" , edit_user_profile_path(@subbu.user), :text => 'Edit Profile'
      assert_select "li:nth-of-type(2) a[href=?]" , "#", :text => 'Compose Message'
      assert_select "li:nth-of-type(3) a[href=?]" , "#", :text => 'Add/Remove Papers'
      assert_select "li div#post-message", "Subject"
    end
    assert_tab_count(3)
    assert_tab("Home", "home-tab")
    assert_tab("Papers", "papers-tab")
    assert_tab("Exams", "exams-tab")   
  end
  
  test "Others should only view & not edit teacher profile. Rest of the breadcrumbs & actions should be the same" do
    get :show, :id => @subbu.to_param
    assert_response :success
    assert_select 'div#breadcrumbs ul#crumbs li a[href=?]', school_path(@sboa), :text => @sboa.name
    assert_select 'div#breadcrumbs ul#crumbs li a[href=?]', "", :text => @subbu.name
    assert_select "ul#right-bar" do
      assert_select "li a", :count => 3 #will be changed to 2 later
      assert_select "li a[href=?]" , user_profile_path(@subbu.user), :text => 'View Profile'
      assert_select "li:nth-of-type(2)" do
        assert_select "a[href=?]" , "#", :text => 'Compose Message'
      end
      assert_select "li:nth-of-type(3)" do
        assert_select "a[href=?]" , "#", :text => 'Add/Remove Papers'
      end
      assert_select "li div#post-message", "Subject"
    end
    assert_tab_count(3)
    assert_tab("Home", "home-tab")
    assert_tab("Papers", "papers-tab")
    assert_tab("Exams", "exams-tab")  
  end
  
  test "create teacher success thru xhr" do
    assert_difference('Teacher.count') do
      xhr :post, :create,{ :user => {:email => "sboateacher@gmail.com"}, :school_id =>@sboa.id }
    end    
    assert_response :success
    assert_template "teachers/create_success"
  end
  
  test "create teacher failure thru xhr" do
    xhr :post, :create , {:user => {:email => @sunil.user.email}, :school_id =>@sboa.id}
    assert_response :success
    assert_template "teachers/create_error"
  end
  
#  test "add subjects thru xhr" do
#    xhr :post, :add_subjects, {:id => @sunil, :teacher => {:subject_ids => [@eng.to_param ,@mal.to_param]}}
#    assert @sunil.current_subjects.include?(@eng)
#    assert @sunil.current_subjects.include?(@mal)
#    assert_response :success
#  end
#  
#  test "update klass allotments thru xhr" do
#    xhr :post, :add_klasses, {:id => @sunil_physics, :teacher_subject_allotment => { :klass_ids => [@one_A.to_param ,@two_B.to_param]}}
#    assert @sunil_physics.current_klasses.include?(@one_A)
#    assert @sunil_physics.current_klasses.include?(@two_B)
#    assert_response :success
#  end
  
end
