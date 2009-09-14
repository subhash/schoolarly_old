require 'test_helper'

class ExamTypeTest < ActiveSupport::TestCase
  
  def setup
    @halfYearly = exam_types(:half_yearly)    
  end
  
  test "sanity" do
    assert_equal  1, @halfYearly.exam_groups.size
  end
end
