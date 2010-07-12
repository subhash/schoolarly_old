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
    students_with_scores | klass.students.for_paper(klass.papers.find_by_school_subject_id(SchoolSubject.find_by_school_id_and_subject_id(klass.school.id, subject.id).id))
  end
  
  def participants
    teacher ? (students + [teacher]) : students
  end
  
  def klass
    assessment.klass
  end
  
  def subject
    assessment.subject
  end
  
  def teacher
    assessment.teacher
  end
  
  def title
    assessment.name + " "+ name+" - "+ subject.name
  end
  
  
  def duration
    event ? ((event.end_time.to_time - event.start_time.to_time)/1.hour): 0
  end
  
  
end
