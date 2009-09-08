require 'test_helper'

class TeacherAllotmentTest < ActiveSupport::TestCase
  
  def setup
    @sunil = teachers(:sunil)
    @treasa = teachers(:treasa)
    @mal = subjects(:malayalam)
    @eng = subjects(:english)
    @klass = klasses(:two_B)
    
  end
  test "teacher-allotment" do
    t1 = TeacherAllotment.new(:is_current => true)
    t1.teacher = @sunil
    t1.klass = @klass
    t1.subject = @mal
    assert t1.save
    assert @sunil.current_klasses.include?(@klass)
    assert @klass.teachers.include?(@sunil)
    
    t2 = TeacherAllotment.new(:is_current => true)
    t2.teacher = @treasa
    t2.klass = @klass
    t2.subject = @eng
    assert t2.save
    assert_equal 2,@klass.teachers.size
  end
  
end
