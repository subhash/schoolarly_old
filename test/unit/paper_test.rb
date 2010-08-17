require 'test_helper'

class PaperTest < ActiveSupport::TestCase
  def setup
    @school=schools(:st_teresas)
    @mal=school_subjects(:st_teresas_malayalam)
    @eng=school_subjects(:st_teresas_english)  
    @klass = Klass.create(:level => levels(:two), :division => 'G', :school => @school)
  end
  
  test "klass-paper-assessments" do
    paper =  Paper.new(:school_subject => @mal, :klass => @klass)
    assert_difference '@klass.reload.papers.size' do
      paper.save
    end
    assert_equal paper.assessments.size, @klass.assessment_groups.size 
    assert_equal paper.formative_assessments.size, @klass.assessment_groups.FA.size 
    assert_equal paper.summative_assessments.size, @klass.assessment_groups.SA.size 
    @klass.school_subject_ids = [@mal.id, @eng.id]
    @klass.save!
    assert_equal @klass.assessments.size, (@klass.assessment_groups.size * 2)
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
