require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  
  test "CRUD" do
    at = assessment_tools(:reading_FA1_english)
    activity = Activity.new(:assessment_tool => at, :max_score => 20)
    assert_difference 'at.reload.activities.size' do
      activity.save!
    end  
    assert_difference 'at.reload.activities.size',-1 do
      activity.destroy
    end
  end
  
end
