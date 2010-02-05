require 'test_helper'

class ExamGroupsControllerTest < ActionController::TestCase

  def setup
    activate_authlogic
    @mal = subjects(:malayalam)
    @eng = subjects(:english)
    @stTeresas = schools(:st_teresas)
    @one_A=klasses(:one_A)
    @exam_type = exam_types(:half_yearly)
    UserSession.create(@stTeresas.user)
  end
  
  test "should create exam group" do
    assert_difference ('ExamGroup.count', 1) do
      post :create, :exam_group => {:exam_type_id => @exam_type.to_param, :klass_id => @one_A.to_param}, :exam => {:subject_ids => [@eng.to_param, @mal.to_param]}, :entity_class => 'Klass', :entity_id => @one_A
    end
    assert_response :success
  end
  
end
