class Score < ActiveRecord::Base
  belongs_to :student
  belongs_to :activity
  
  after_create :send_message
  
  def max_score
    activity.max_score
  end
  #  
  #  def weightage
  #    exam.activity.assessment.weightage
  #  end
  
  def send_message
    str = "Score in #{activity.title} - #{score}/#{max_score} "
    student.school.user.send_message(student.user, str, str)
  end  
  
  #  score as a number
  def self.grade(score)
    if score
      case
        when score >= 91
        return :A1
        when score >=81
        return :A2
        when score >=71
        return :B1
        when score >=61
        return :B2
        when score >=51
        return :C1
        when score >=41
        return :C2
        when score >=33
        return :D
        when score >=21
        return :E1
      else
        return :E2      
      end
    end
  end
end
