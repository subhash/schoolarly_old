require 'test_helper'

class PaperTest < ActiveSupport::TestCase
  def setup
    @school=schools(:st_teresas)
    @mal=subjects(:malayalam)
    @eng=subjects(:english)  
    @klass = klasses(:two_B)
  end
  
  test "klass-paper-relationship" do
    assert_difference '@klass.papers.size' do
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
  
  test "invalid papers" do
    assert_raise ActiveRecord::RecordInvalid do
      Paper.new.save!
    end        
    assert_raise ActiveRecord::RecordInvalid do
      @klass.papers << Paper.new
      @klass.save!
    end
  end
end
