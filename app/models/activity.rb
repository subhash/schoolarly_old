class Activity < ActiveRecord::Base
  belongs_to :assessment_tool
  belongs_to :event
  
  has_one :assessment, :through => :assessment_tool
  
  has_many :scores
  has_many :students_with_scores, :through => :scores, :source => :student
  
  accepts_nested_attributes_for :event
  
  validates_numericality_of :max_score
  
  def name
    assessment_tool.name
  end
  
  def students
    students_with_scores | assessment.students
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
    event ? ((event.end_time.to_time - event.start_time.to_time)/1.hour): 0
  end
  
  def destroyable?
    self.scores.empty? and assessment.fa?
  end
  
end
