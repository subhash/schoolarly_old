require 'test_helper'
require 'authlogic/test_case'

class KlassesControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @stTeresas=schools(:st_teresas)
    @one_A=klasses(:one_A)
    @two_B = klasses(:two_B)    
    UserSession.create(@stTeresas.user)
    @english = subjects(:english)
    @malayalam = subjects(:malayalam)
    @maths = subjects(:maths)
    @subhash = students(:subhash)
    @reeny = students(:reeny)
    @shenu = students(:shenu)
  end
  
  test "create klass failure" do
    assert_no_difference ['Klass.count','@stTeresas.klasses.size'] do
      xhr :post, :create, :klass => {:level => @one_A.level, :division => @one_A.division}, :school_id => @stTeresas.id
    end    
    assert_response :success
    assert_template "klasses/create_error"
  end
  
  test "create klass success" do
    assert_difference ['Klass.count','@stTeresas.klasses.size'] do
      xhr :post, :create, :klass => {:level => 1.to_sym, :division => "A"}, :school_id =>  @stTeresas.id
    end    
    assert_response :success
    assert_template "klasses/create_success"
  end
  
  test "klass should show breadcrumb with school, klass & 3 actions" do
    get :show, :id => @one_A.to_param
    assert_response :success
    assert_breadcrumb(@stTeresas.name, school_path(@stTeresas), 1)
    assert_breadcrumb( @one_A.name)
    assert_action_count(3)
    assert_action('Add Students',:url =>  '#')
    assert_action('Add Subjects', :url => '#')
    assert_action('Add Exams',:url =>  '#')
  end
  
  test "klass should show all Students, Subjects, Exams tabs" do
    get :show, :id => @one_A.to_param
    assert_response :success
#    assert_tab_count(3)
    #    assert_tab("Students", "students-tab")
    #    assert_tab("Subjects", "subjects-tab")
    #    assert_select '#students-tab tr[id*=student_]', @one_A.students.size
    #    assert_select '#subjects-tab tr[id*=subject-]', @one_A.subjects.size
    # NOT A GOOD WAY TO TEST for the no. of students. What if there are rows for table headers, footers, etc? (Instead we may have to use CSS classes)   
    #    assert_select 'div#subjects-tab table tr', 1 + @one_A.subjects.size
    #    assert_select 'div#exams-tab table', @one_A.exam_groups.size
    #    assert_select 'div#exams-tab table td a.ui-icon', 3 * @one_A.exams.size
  end
  
  #  TODO not sure how to do this with login incorporated
  test "destroy klass success" do
    assert_no_difference ['Klass.count','@stTeresas.klasses.size'] do
      xhr :post, :create, :klass => {:level => 1.to_sym, :division => "A"}, :school_id =>  @stTeresas.id
      xhr :get, :destroy, :id => assigns(:klass).id
    end
    assert_response :success
    assert_template "klasses/destroy"
  end
  
  #  TODO - behaviour interlinked with exception handling
  test "destroy klass failure" do    
    assert_raise ActiveRecord::StatementInvalid  do 
      get :destroy, :id => @one_A.to_param
    end
  end
  
  test "destroy klass with dependents for school-admin" do
  #    TODO
end

test "add students" do
  assert_difference '@one_A.reload.students.size', 2 do
    session[:redirect] = klass_path(@one_A)
    xhr :post, "add_students", {:klass => {:student_ids => [@subhash.to_param , @reeny.to_param, ""]}, :id => @one_A.to_param }
  end
  assert_response :success
  assert_template "klasses/add_students"   
end

test "remove student" do
  assert_difference '@one_A.reload.students.size', -1 do
    xhr :get, "remove_student", :id => @shenu.to_param 
  end
  assert_response :success
  assert_template "klasses/remove_student"   
end
end
