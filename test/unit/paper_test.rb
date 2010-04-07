require 'test_helper'

class PaperTest < ActiveSupport::TestCase
  def setup
    @school=schools(:st_teresas)
    @mal=subjects(:malayalam)
    @eng=subjects(:english)  
    @klass = klasses(:two_B)
  end
  
  test "school-paper-relationship" do
    #    @klass.papers << Paper.new(:subject => @mal)
    #    @klass.subjects <<  Paper.new(:subject => @eng)
    #    assert_equal 2,@school.papers.size
  end
  
  test "klass-paper-relationship" do
    assert_difference('@klass.papers.size') do
      @klass.papers << Paper.new(:subject => @mal)
    end
    @klass.papers <<  Paper.new(:subject => @eng)
    assert @klass.save!
    assert @klass.subjects.include?(@mal)
    @klass.papers << Paper.new(:subject => @eng)
    assert_raise ActiveRecord::RecordInvalid do
      @klass.save!
    end
  end
end
