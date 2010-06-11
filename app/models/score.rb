class Score < ActiveRecord::Base
  belongs_to :student
  belongs_to :exam
  has_one :klass, :through => :exam
  
  def max_score
    exam.activity.assessment.max_score
  end
  
  def weightage
    exam.activity.assessment.weightage
  end
  
  
  def self.mean(scores)
    Score.average(:score, :conditions => {:id => scores.collect(&:id)})
  end
  
  # aggregate for scores for same subject in one category (eg. FA1)- hence no filtering for subject or exam name  
  #  applicable only if all the scores are entered for all the activities in FA1
  def self.aggregate(scores)
    grouped_scores = scores.group_by{|s|s.exam.activity}
    if grouped_scores.size == scores.first.klass.activities.find_all_by_assessment_id(scores.first.exam.activity.assessment.id).size
      averages = grouped_scores.collect{|a, s| Score.mean(s)}
       (averages.sum.to_f/averages.size).round(3)
    else     
      nil
    end
  end
  
  
  # weighted aggregate for scores for same subject in one category (eg. FA1)
  def self.weighted_aggregate(scores)
    unless scores.blank? or aggregate(scores).nil?
     (aggregate(scores)/scores.first.max_score) * scores.first.weightage * 100
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
end
