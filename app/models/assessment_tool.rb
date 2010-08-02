class AssessmentTool < ActiveRecord::Base
  
  belongs_to :assessment
  
  has_one :klass, :through => :assessment
  
  has_many :activities, :dependent => :destroy
  
  has_many :scores, :through => :activities do
    def of_student(student_id)
      find :all, :conditions => {:student_id => student_id}
    end
  end
  
  validates_presence_of :name
  
  validates_numericality_of :weightage, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  
  validate_on_update :best_of_valid
  
  def best_of_valid
    unless (1..activities.size).include?(best_of)
      errors.add("Best of should be in 1..#{activities.size}")
    end
  end
  
  def average_score_for(student)
    student_scores = scores.of_student(student.id).collect{|s|(s.score/s.max_score)}
    if student_scores.size >= best_of
      student_scores = student_scores.sort.reverse.slice(0,best_of)
      avg = (student_scores.sum/student_scores.size) * max_score
    else
      nil
    end
  end
  
    
  def weighted_average_for(student)
      (average_score_for(student) * weightage/100) if average_score_for(student)
  end

  
end
