require 'test_helper'
require 'authlogic/test_case'

class KlassesControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @stTeresas=schools(:st_teresas)
    @one_A=klasses(:one_A)
    UserSession.create(@stTeresas.user)
  end
  
  test "create klass failure" do
    assert_no_difference ['Klass.count','@stTeresas.klasses.size'] do
      xhr :post, :create, :klass => {:level => @one_A.level, :division => @one_A.division, :year => 2009}, :school_id => @stTeresas.id
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
  
  test "klass should show breadcrumb with school, klass & 2 actions" do
    get :show, :id => @one_A.to_param
    assert_response :success
    #    assert_select 'ul#breadcrumbs li a[href=?]', school_path(@stTeresas), :text => @stTeresas.name
    assert_breadcrumb(@stTeresas.name, :url => school_path(@stTeresas), :index => 1)
    #    assert_select 'ul#breadcrumbs strong', @one_A.name
    assert_breadcrumb( @one_A.name)
    assert_action_count(2)
    assert_action('Add Exam Group',:url =>  '#')
    assert_action('Add/Remove Subjects', :url => '#')
    #    assert_select "#action_box" do
    #      assert_select ".button a", :count => 2
    #      assert_select ".button a[href=?]" , '#', :text => 'Add Exam Group'
    #      assert_select ".button a[href=?]" , '#', :text => 'Add/Remove Subjects'
    #    end 
  end
  
  test "klass should show all Students, Subjects, Exams tabs" do
    get :show, :id => @one_A.to_param
    assert_response :success
    assert_equal @one_A.current_students.size, assigns(:students).size
    assert_equal @one_A.subjects.size, assigns(:subjects).size
    assert_tab_count(3)
    assert_tab("Students", "students-tab")
    assert_tab("Subjects", "subjects-tab")
    assert_select '#students-tab tr[class*=student]', @one_A.current_students.size
    assert_select '#subjects-tab tr[id*=subject-]', @one_A.subjects.size
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
    assert_template "klasses/delete"
  end
  
  test "destroy klass failure" do
    assert_no_difference ['Klass.count','@stTeresas.klasses.size'] do
      get :destroy, :id => @one_A.to_param
    end
    assert_response :redirect
  end
  
end
