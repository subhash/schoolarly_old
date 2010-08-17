require 'test_helper'

class PaperTest < ActiveSupport::TestCase
  def setup
    @school=schools(:st_teresas)
    @mal=school_subjects(:st_teresas_malayalam)
    @eng=school_subjects(:st_teresas_english)  
    @klass = klasses(:one_A)
  end
  
  test "klass-paper-relationship" do
    assert_difference '@klass.papers.size' do
      Paper.create(:school_subject => @mal, :klass => @klass)
    end
    @klass.school_subject_ids = [@mal.id, @eng.id]
    assert @klass.school_subjects.include?(@mal)
    @klass.papers << Paper.new(:school_subject => @eng)
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
