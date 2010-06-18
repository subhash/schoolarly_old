class Score < ActiveRecord::Base
  belongs_to :student
  belongs_to :exam
  has_one :activity, :through => :exam
  has_one :klass, :through => :exam
  has_one :subject, :through => :exam
  
  after_create :send_message
  
  def max_score
    exam.activity.assessment.max_score
  end
  
  def weightage
    exam.activity.assessment.weightage
  end
  
  def send_message
    str = "Score in #{exam.title} - #{score}/#{max_score} "
    student.school.user.send_message(student.user, str, str)
  end  
  
  def self.mean(scores)
   (scores.sum(&:score).to_f/scores.size).round(3)
  end
  
  # aggregate for scores for same subject in one category (eg. FA1)- hence no filtering for subject or exam name  
  #  applicable only if all the scores are entered for all the activities in FA1
  def self.aggregate(scores)
    grouped_scores = scores.group_by{|s|s.exam.activity}
    if grouped_scores.size == scores.first.klass.current_exams_for(scores.first.activity.assessment, scores.first.subject).group_by{|e|e.activity}.size
      averages = grouped_scores.collect{|a, s| Score.mean(s)}
      (averages.sum.to_f/averages.size).round(3)
    else     
      nil
    end
  end
  
  
  # weighted aggregate for scores for same subject in one category (eg. FA1)
  def self.weighted_aggregate(scores)
    unless scores.blank? or aggregate(scores).nil?
     (aggregate(scores)/scores.first.max_score) * scores.first.weightage
    else nil
    end
  end
  
  # aggregate for scores for same subject in one subject & one term,  passed as a collection
  def self.total(scores)
    aggregates = scores.group_by{|s|s.exam.name}.collect{|activity, a_scores| weighted_aggregate(a_scores)}
    if aggregates.compact.size == aggregates.size
      aggregates.sum
    else
      nil
    end
  end
  
  #  score as a number
  def self.grade(score)
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
