require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  def setup
    @school=schools(:st_teresas)
    @mal=subjects(:malayalam)
    @eng=subjects(:english)  
    @klass = klasses(:two_B)
  end
  
  test "school-subject-relationship" do
    @klass.subjects << @mal
    @klass.subjects << @eng
    assert_equal 2,@school.subjects.size
  end
  
  test "klass-subject-relationship" do
    @klass.subjects << @mal
    assert_equal 1,@klass.subjects.size
    @klass.subjects << @eng
    assert @klass.save
    eng_klasses = @eng.klasses
    assert eng_klasses.include?(@klass)
    assert @klass.subjects.include?(@mal)
  end
end
