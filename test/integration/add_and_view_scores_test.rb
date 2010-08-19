require 'test_helper'
require 'authlogic/test_case'

class AddAndViewScoresTest < ActionController::IntegrationTest
#  fixtures :all
#  
#  EXAM_DETAILS = {:subject_id => @mal.to_param, :venue => 'at klass'}
#  SUBJECTS = [@eng.to_param, @san.to_param]
#  
#  def setup
#    @treasa = teachers(:treasa)
#    @eg = exam_groups(:half_yearly_two_B)
#    @mal = subjects(:malayalam)
#    @san = subjects(:sanskrit)
#    @eng = subjects(:english)
#    @reeny = students(:reeny)
#    activate_authlogic
#  end
#  
#  def logs_in(user)
#    UserSession.create(user)
#  end
#  
#  def is_viewing(page)
#    assert_response :success
#    assert_template page
#  end
#  
#  def adds_exam(args)
#    xhr :post, 'exams/create', args 
#    assert_response :success
#    assert_template 'exams/create_success'
#  end
#  
#  def add_scores(args)
#    xhr :post, 'scores/row_edit', args
#    assert_response :success
#    assert_template 'scores/row_edit'
#  end
#  
#  def check_student_score(eg,exam,score)
#    assert_select "#examgroup-#{eg.id} #exam-#{exam.id} td:nth-child(9)", :text => score
#  end
#  
#  test "teacher adds exam & then scores & it should be available in students show" do
#    logs_in             @treasa.user
#    get                 'teachers/' + @treasa.to_param
#    is_viewing          'teachers/show'
#    adds_exam           :exam_group_id => @eg.to_param, :exam => {:subject_id => @mal.to_param, :venue => 'at klass'}, :entity_class => 'Teacher', :entity_id => @treasa.to_param, :subjects=>SUBJECTS
#    @exam=Exam.find_by_exam_group_id_and_subject_id(@eg.id, @mal.id)
#    add_scores          :score => 90, :exam => @exam.to_param, :id => @reeny.to_param
#    get                 'students/' + @reeny.to_param
#    is_viewing          'students/show'
#    check_student_score @eg, @exam, 90
#  end
  
end
