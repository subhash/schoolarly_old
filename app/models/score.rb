class Score < ActiveRecord::Base
  belongs_to :student
  belongs_to :exam
  
  def self.aggregate(scores)
    averages = scores.group_by{|s|s.exam.activity}.collect{|a, scores| Score.average(:score, :conditions => {:id => scores.collect(&:id)})}
    (averages.sum.to_f/averages.size).round(2)
  end
  
end
