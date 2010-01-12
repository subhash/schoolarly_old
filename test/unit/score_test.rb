require 'test_helper'

class ScoreTest < ActiveSupport::TestCase
  def setup
    @shenuScore1 = scores(:shenu_score1)
    @shenuScore2 = scores(:shenu_score2)
    @paruScore1 = scores(:paru_score1)
  end
  
  test "sanity" do
    assert_equal students(:shenu), @shenuScore1.student
    assert_equal students(:paru), @paruScore1.student
  end
  
  test "subject-score relationship" do
    maths = subjects(:maths)
    s = maths.exams.first.scores
    assert s.include?(@shenuScore1)
    assert s.include?(@paruScore1)
  end
end
