require 'test_helper'

class KlassTest < ActiveSupport::TestCase
  def setup
    @klass = klasses(:one_A)
    @teacher = teachers(:sunil)
    @school = schools(:st_teresas)
  end
  
  test "klass-teacher relationship" do
    assert_equal @klass.school, @school
    assert_equal @klass.class_teacher,@teacher
  end
end
