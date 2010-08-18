require 'test_helper'

class ScoreTest < ActiveSupport::TestCase

  def setup
    @reading_FA1_english1 = activities(:reading_FA1_english1)
    @reading_FA1_english2 = activities(:reading_FA1_english2)
    @oneAstudent = students(:oneA_student)
    @score = Score.create(:student => @oneAstudent, :activity => @reading_FA1_english1, :score => 10)
  end
  
  test "belongs to student & activity" do
    assert_equal @oneAstudent, @score.student
    assert @oneAstudent.scores.include?(@score)
    assert @reading_FA1_english1.scores.include?(@score)
    assert_equal @reading_FA1_english1, @score.activity
  end
  
  test "maximum score" do
    assert_equal @reading_FA1_english1.max_score, @score.max_score
  end
  
  test "send message after create" do
    assert_difference('Message.count', 1) do
      score = Score.create(:student => @oneAstudent, :activity => @reading_FA1_english2, :score => 10)        
    end      
  end
  
  test "grade" do
    assert_equal :A1, Score.grade(99)
    assert_equal :A2, Score.grade(89)
    assert_equal :E2, Score.grade(@score.score)
  end
  
end
