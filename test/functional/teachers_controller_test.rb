require 'test_helper'
require 'authlogic/test_case'

class TeachersControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @sboa = schools(:sboa)
    @stTeresasSchool = schools(:st_teresas)
    @subbu = teachers(:v_subramaniam)
    @sunil = teachers(:sunil)
    @one_A = klasses(:one_A)
    @two_B = klasses(:two_B)
    @mal = subjects(:malayalam)
    @eng = subjects(:english)
    @antony = teachers(:teacher_antony)
    @fourDEng_antony=papers(:four_D_english_antony)
    @fourDMal_antony=papers(:four_D_malayalam_antony)
    @sanskrit = subjects(:sanskrit)
    @tamil = subjects(:tamil)
    @oneATamilPaper=papers(:one_A_tamil)
    @twoBSanskritPaper=papers(:two_B_sanskrit)
    @no_school_teacher=teachers(:no_school_teacher)
    UserSession.create(@sboa.user)
  end
  
  test "teacher should show breadcrumbs with school name, teacher name/email and 2 actions" do
    UserSession.create(@subbu.user)
    get :show, :id => @subbu.to_param
    assert_response :success
    assert_breadcrumb(@sboa.name, school_path(@sboa),1)
    assert_breadcrumb(@subbu.name, "",2)
    assert_action_count(3)
    assert_action('Edit Profile', :url => edit_user_profile_path(@subbu.user), :index => 1)
    assert_action('Compose Message', :index => 2)
    assert_action('Add/Remove Papers', :index => 3)
    assert_select "ul#right-bar li div#post-message", "Subject"
    assert_tab_count(3)
    assert_tab("Home", "home-tab")
    assert_tab("Papers", "papers-tab")
    assert_tab("Exams", "exams-tab")   
  end
  
  test "Others should only view & not edit teacher profile. Rest of the breadcrumbs & actions should be the same" do
    get :show, :id => @subbu.to_param
    assert_response :success
    assert_breadcrumb(@sboa.name, school_path(@sboa),1)
    assert_breadcrumb(@subbu.name, "",2)
    assert_action_count(3) #will be changed to 2 later
    assert_action('View Profile', :url => user_profile_path(@subbu.user), :index => 1)
    assert_action('Compose Message', :index => 2)
    assert_action('Add/Remove Papers', :index => 3)
    assert_select "ul#right-bar li div#post-message", "Subject"
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
  
  test "add papers thru xhr" do
    session[:redirect]=teachers_path(@sunil)
    xhr :post, :update_papers, {:id => @sunil, :klass => {:paper_ids => [@oneATamilPaper.to_param ,@twoBSanskritPaper.to_param]}}
    assert @sunil.subjects.include?(@tamil)
    assert @sunil.subjects.include?(@sanskrit)
    assert_response :success
  end
  
  test "remove paper thru xhr" do
    xhr :post, :remove_paper, {:id => @fourDEng_antony.to_param}
    assert_response :success
    assert !@antony.papers.include?(@fourDEng_antony)
    assert @antony.papers.include?(@fourDMal_antony)
    assert !@antony.subjects.include?(@eng)
    assert @antony.subjects.include?(@mal)
  end
    
  test "add teacher to school" do
    session[:redirect]=teacher_path(@no_school_teacher)
    xhr :post, :add_to_school, {:id => @no_school_teacher, :entity => {:school_id => @stTeresasSchool.to_param}}
      assert_response :success
      assert :template => teacher_path(@no_school_teacher)
  end
  
end
