class Exam < ActiveRecord::Base
  belongs_to :exam_type
  belongs_to :subject
  belongs_to :teacher
  has_many :scores
  has_many :students, :through => :scores
  belongs_to :event, :dependent => :destroy
  belongs_to :klass
  belongs_to :academic_year
  
  accepts_nested_attributes_for :event
  accepts_nested_attributes_for :scores
  
  def score_of(student)
    score = scores.select{|score| score.student == student}.first
    if score then return score.score end
  end
  
  def is_destroyable?
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
  
  def participants
    teacher ? (students + [teacher]) : students
  end
  
end
