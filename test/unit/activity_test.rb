require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  
  test "CRUD" do
    at = assessment_tools(:reading_FA1_english)
    activity = Activity.new(:assessment_tool => at, :max_score => 20)
    assert_difference 'at.reload.activities.size' do
      activity.save!
    end  
    assert_equal activity.assessment, at.assessment
    assert_difference 'at.reload.activities.size',-1 do
      activity.destroy
    end
  end
  
  test "validations" do
    at1 = assessment_tools(:reading_FA1_english)
    assert at1.best_of >= at1.activities.size
    at1.activities.each do |a|
      unless at1.activities.size == 1
        a.destroy
        at1.save
      end
    end
    assert_equal at1.activities.size, at1.best_of 
    activity = assessment_tools(:classtest_FA1_english).activities.first
    activity.max_score = -1
    assert_raise ActiveRecord::RecordInvalid do
      activity.save!
    end  
  end
  
  test "call backs" do
    at1 = assessment_tools(:reading_FA1_english)
    at1.activities.each do |a|
      a.destroy
    end
    assert_raise ActiveRecord::RecordNotFound do
      at1.reload
    end
  end
  
end
