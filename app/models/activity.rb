class Activity < ActiveRecord::Base
  
  belongs_to :assessment_tool
  belongs_to :event
  
  has_one :assessment, :through => :assessment_tool
  
  has_many :scores
  has_many :students_with_scores, :through => :scores, :source => :student
  
  validates_numericality_of :max_score
  
  after_destroy :adjust_best_of
  
  accepts_nested_attributes_for :event
  
  def name
    assessment_tool.name
  end
  
  def students
    students_with_scores | assessment.current_students
  end
  
  def participants
    students_with_scores | assessment.current_participants
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
  
  def destroyable?
    self.scores.empty?
  end
  
  def adjust_best_of
    if assessment_tool.best_of > assessment_tool.activities.size
      assessment_tool.best_of =  assessment_tool.activities.size
      assessment_tool.save!
    end
  end 
    
  def duration
    event ? ((event.end_time.to_time - event.start_time.to_time)/1.hour): 0
  end
  
end
