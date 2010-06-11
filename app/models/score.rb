class Score < ActiveRecord::Base
  belongs_to :student
  belongs_to :exam
  
  
  def max_score
    exam.activity.assessment.max_score
  end
  
  def weightage
    exam.activity.assessment.weightage
  end
  
  
  # aggregate for scores for same subject in one category (eg. FA1)- hence no filtering for subject or exam name  
  def self.aggregate(scores)
    averages = scores.group_by{|s|s.exam.activity}.collect{|a, scores| Score.average(:score, :conditions => {:id => scores.collect(&:id)})}
     (averages.sum.to_f/averages.size).round(2)
  end
  
  # weighted aggregate for scores for same subject in one category (eg. FA1)
  def self.weighted_aggregate(scores)
    unless scores.blank?
      (aggregate(scores)/scores.first.max_score) * scores.first.weightage * 100
    else nil
    end
  end
  
  # aggregate for scores for same subject in one subject & one term,  passed as a collection
  def self.total(scores)
    scores.group_by{|s|s.exam.activity_name}.collect{|activity, a_scores| weighted_aggregate(a_scores)}.sum
  end
end
