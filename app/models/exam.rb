class Exam < ActiveRecord::Base
  belongs_to :activity
  belongs_to :subject
  belongs_to :teacher
  has_many :scores
  has_many :students_with_scores, :through => :scores, :source => :student
  belongs_to :event
  belongs_to :klass
  has_one :school, :through => :klass
  belongs_to :academic_year
  
  accepts_nested_attributes_for :event
  accepts_nested_attributes_for :scores
  
  def name
    activity.assessment.name
  end
  
  def assessment_type
   activity.assessment.assessment_type
  end
  
  def term
    activity.assessment.term
  end
  
  def title
    name + " " + activity_name + " - "+ subject.name
  end
  
  def long_desc
    description.empty? ? title : title + "["+description+"]"
  end
  
  def activity_name
    activity.activity
  end
  
  def score_of(student)
    score = scores.select{|score| score.student == student}.first
    if score then return score.score end
  end
  
  def destroyable?
    return self.scores.empty? 
  end
  
  def date
    event ? event.start_time.to_date : nil
  end
  
  def time
    event ? event.start_time.to_s(:time) : nil
  end
  
  def duration
    event ? ((event.end_time.to_time - event.start_time.to_time)/1.hour): 0
  end
  
    
  def students
    students_with_scores + klass.students.for_paper(klass.papers.find_by_subject_id(subject.id).id)
  end
  
  def participants
    teacher ? (students + [teacher]) : students
  end
  
  def similar
    klass.exams.find_all_by_activity_id_and_academic_year_id_and_subject_id(activity.id, academic_year.id, subject.id)
  end

end
