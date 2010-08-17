require 'test_helper'

class AssessmentToolTest < ActiveSupport::TestCase
  def setup
    @school=schools(:st_teresas)
    @eng=school_subjects(:st_teresas_english)  
    @klass = klasses(:one_A)
  end
  
  test "CRUD" do
#    @klass.papers << Paper.create(:school_subject => @eng)
#    assert_equal 6, @klass.assessments
  end
  
end
