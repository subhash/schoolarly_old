require 'test_helper'

class ExamsControllerTest < ActionController::TestCase
  
  def setup
    @mal = subjects(:malayalam)
    @eg = exam_groups(:half_yearly_two_B)
  end

#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:exams)
#  end
#
#  test "should get new" do
#    get :new
#    assert_response :success
#  end

#  test "should get ajax new" do
#    xhr :get, :new
#    assert_response :success
#  end
  
#  test "should create exam" do
#    assert_difference('Exam.count',1) do
#      post :create, :exam => {:exam_group => @eg, :subject => @mal }
#    end
#    #assert_response :success
#    assert_redirected_to exam_path(assigns(:exam))
#  end
#
#  test "should show exam" do
#    get :show, :id => exams(:english_class_test_1).to_param
#    assert_response :success
#  end
#
#  test "should get edit" do
#    get :edit, :id => exams(:english_class_test_1).to_param
#    assert_response :success
#  end
#
#  test "should update exam" do
#    put :update, :id => exams(:english_class_test_1).to_param, :exam => { }
#    assert_redirected_to exam_path(assigns(:exam))
#  end
#
#  test "should destroy exam" do
#    assert_difference('Exam.count', -1) do
#      delete :destroy, :id => exams(:english_class_test_1).to_param
#    end
#
#    assert_redirected_to exams_path
#  end
end
