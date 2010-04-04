require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  
  def setup
    @mary_kutty = teachers(:mary_kutty)
    @antony = teachers(:teacher_antony)
  end
  
  test "all teachers are users" do
    assert @mary_kutty.user
    assert teachers(:sunil).user
    assert teachers(:v_subramaniam).user
    assert teachers(:treasa).user
  end
  
  test "teacher antony can be the class teacher of more than one class" do
    assert_equal 4, @antony.owned_klasses.size
  end
  
end
