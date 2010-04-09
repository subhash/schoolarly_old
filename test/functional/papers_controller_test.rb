require 'test_helper'

class PapersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
#    
#  test "add subjects" do
#    xhr :post, "add_subjects", {:klass => {:subject_ids => [@malayalam.to_param , @maths.to_param ]}, :id => @one_A.to_param }
#    assert_response :success
#    assert_template "klasses/add_subjects"
#    # add_subject_form is made such that the subjects which are allotted will be disabled for select
#    # so, in the action add_subjects we have to explicitly add the allotted subjects to class
#    assert_equal (2 + @one_A.allotted_subjects.size), @one_A.subjects.size
#  end
end
