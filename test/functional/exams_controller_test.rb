require 'test_helper'
require 'authlogic/test_case'

class ExamsControllerTest < ActionController::TestCase
  
  def setup
    activate_authlogic
    @mal = subjects(:malayalam)
    @san = subjects(:sanskrit)
    @eg = exam_groups(:half_yearly_two_B)
    @exam_group = exam_groups(:class_test_1_one_A)
    @exam = exams(:english_class_test_1)
    @stTeresas = schools(:st_teresas)
    @one_A=klasses(:one_A)
    UserSession.create(@stTeresas.user)
  end

  test "should get ajax new" do
    xhr :get, :new, :exam_group => @exam_group.to_param, :entity_class => 'Klass', :entity_id => @one_A
    assert_response :success
    assert_template :new
  end
  
#  test "should create exam" do
#  #  assert_difference('@eg.reload.exams.size') do
#      xhr :post, :create, :exam_group_id => @eg.to_param, :exam => {:subject_id => @mal.to_param, :venue => 'at klass'}, :entity_class => 'School', :entity_id => @eg.klass.school.id, :subjects=>[@mal.to_param, @san.to_param]
#  #  end
#    assert_response :success
#    assert_template :create_success
#  end

  test "should show exam" do
    get :show, :id => @exam.to_param
    assert_response :success
    assert_template 'exams/show'
    assert_breadcrumb(@stTeresas.name, school_path(@stTeresas), 1)
    assert_breadcrumb(@one_A.name, klass_path(@one_A), 2)
    assert_breadcrumb(@exam.to_s)
    assert_action_count(0)
  end

  test "should get edit" do
    xhr :get, :edit, :id => @exam.to_param, :entity_class => 'Klass', :entity_id => @one_A
    assert_response :success
    assert_template :edit
  end

  test "should update exam" do
    xhr :put, :update, :id => @exam.to_param, :exam => {:venue => 'new venue' }, :entity_class => 'Klass', :entity_id => @one_A
    assert_equal 'new venue',  @exam.reload.venue
    assert_response :success
    assert_template :update_success
  end

  test "should destroy exam" do
    assert_difference('Exam.count', -1) do
      xhr :delete, :destroy, :id => @exam.to_param, :entity_class => 'Klass', :entity_id => @one_A
    end
    assert_response :success
    assert_template :destroy
  end
  
end
