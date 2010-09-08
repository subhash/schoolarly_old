class Activity < ActiveRecord::Base
  
  belongs_to :assessment_tool
  belongs_to :event
  
  has_one :assessment, :through => :assessment_tool
  
  has_many :scores do
    def of_student(id)
      find :first, :conditions => {:student_id => id}
    end
  end
  
  has_many :students_with_scores, :through => :scores, :source => :student
  
  validates_numericality_of :max_score, :greater_than_or_equal_to => 0
  
  after_destroy :adjust_best_of, :unless => :assessment_tool_empty? 
  after_destroy :destroy_event
  after_destroy :destroy_empty_assessment_tool
  
  accepts_nested_attributes_for :event
  
  acts_as_list :scope => :assessment_tool
  
  def name
    (assessment_tool.activities.size > 1) ? "#{assessment_tool.name} #{position}" : assessment_tool.name
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
  
  def school
    assessment.school
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
    
  def destroy_event
     event.event_series.destroy if event
  end
  
  def destroy_empty_assessment_tool
    assessment_tool.destroy if assessment_tool_empty?
  end
  
  def assessment_tool_empty?
    return assessment_tool.activities.size == 0
  end
  
  def duration
    event ? ((event.end_time.to_time - event.start_time.to_time)/1.hour): 0
  end
  
  def teacher
    assessment.teacher if assessment.teacher
  end
  
  def class_teacher
    assessment.class_teacher if assessment.class_teacher
  end
end
