class Score < ActiveRecord::Base
  belongs_to :student
  belongs_to :activity
  
  after_create :send_message
  after_update :send_update_message
  
  def max_score
    activity.max_score
  end
  
  def unit_score
    case score
      when 'N'
      -2
      when 'A'
      0
    else
      score/max_score
    end
  end
  
  def score=(value)
    case value
      when 'N', 'n'
      self[:score] = -2
      when 'A', 'a'
      self[:score] = -1
    else
      self[:score] = value  
    end
  end
  
  def score
    case self[:score]
      when -2 
       'N'
      when -1
       'A'
    else
      self[:score]
    end
  end
  
  def to_sentence
    case score
      when 'N' 
       'Not Applicable'
      when 'A'
       'Absent'
    else
      "#{score}/#{max_score}"
    end
  end
  
  def old_score
    case self.score_was
      when -2 
       'Not Applicable'
      when -1
       'Absent'
    else
      "#{score_was}/#{max_score}"
    end
  end
  
  def send_message
    unless score == 'N'
      str = "Score in #{activity.title} - #{self.to_sentence} "
      student.school.user.send_message(student.user, str, str)
    end
  end  
  
  def send_update_message
    unless self.score == self.score_was 
      if self.old_score == 'Not Applicable'
        send_message
      else
        subject = "Changed score in #{activity.title} - #{self.to_sentence} "
        body = "Score in #{activity.title} is changed from #{self.old_score} to #{self.to_sentence}"
        student.school.user.send_message(student.user, body, subject)
      end
    end
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
