require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  
  def setup
    @mary_kutty = teachers(:mary_kutty)
  end
  
  test "mary kutty has many degrees up her sleeve" do
    assert @mary_kutty.qualifications.include?(qualifications(:bsc_maths))
    assert @mary_kutty.qualifications.include?(qualifications(:bsc_statistics))
  end
  
end
