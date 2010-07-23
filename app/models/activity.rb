class Activity < ActiveRecord::Base
  include MyHelpers
  belongs_to :assessment_tool
  belongs_to :event
  
  has_one :assessment, :through => :assessment_tool
  
  has_many :scores
  has_many :students_with_scores, :through => :scores, :source => :student
  
  validates_numericality_of :max_score
  
  def name
    assessment_tool.name
  end
  
  def students
    students_with_scores | assessment.current_students
  end
  
  def participants
    students_with_scores | assessment.participants
  end
  
  def klass
    assessment.klass
  end
  
  def subject
    assessment.subject
  end
  
  def title
    assessment.name + " "+ name+" - "+ subject.name
  end
  
  def duration
    event ? (interval(event.start_time, event.end_time)): 0
  end

  def destroyable?
    self.scores.empty?
  end
  
end
