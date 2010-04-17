require 'test_helper'
require 'authlogic/test_case'

class ExamGroupsControllerTest < ActionController::TestCase

  def setup
    activate_authlogic
    @mal = subjects(:malayalam)
    @eng = subjects(:english)
    @stTeresas = schools(:st_teresas)
    @one_A=klasses(:one_A)
    @exam_type = exam_types(:half_yearly)
    @eg = exam_groups(:half_yearly_two_B)
    UserSession.create(@stTeresas.user)
  end
  
  test "should create exam group" do
    assert_difference('ExamGroup.count', 1) do
      xhr :post, :create, :exam_group => {:exam_type_id => @exam_type.to_param, :klass_id => @one_A.to_param}, :exam => {:subject_ids => [@eng.to_param, @mal.to_param]}, :entity_class => 'Klass', :entity_id => @one_A
    end
    assert_response :success
    assert_template :create_success
  end
 
  test "should fail exam group creation" do   #TODO not so sure how to make it fail
    assert_difference('ExamGroup.count', 0) do
      xhr :post, :create, :exam_group => {:exam_type_id => nil, :klass_id => @one_A.to_param}, :exam => {:subject_ids => [@eng.to_param, @mal.to_param]}, :entity_class => 'Klass', :entity_id => @one_A
    end
    assert_response :success
    assert_template :create_failure
  end
  
  test "should destroy exam_group" do
    assert_difference('ExamGroup.count', -1) do
      xhr :delete, :destroy, :id => @eg.to_param
    end
    assert_response :success
    assert_template :destroy
  end
  
end
