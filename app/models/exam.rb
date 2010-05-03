class Exam < ActiveRecord::Base
  belongs_to :exam_group
  belongs_to :subject
  belongs_to :teacher
  has_many :scores, :dependent => :destroy
  has_many :students_with_scores, :through => :scores, :source => :student
  has_one :klass, :through => :exam_group
  has_one :exam_type, :through => :exam_group
  belongs_to :event, :dependent => :destroy
  
  accepts_nested_attributes_for :event
  
  def to_s
    return exam_group.exam_type.description + ' for ' + subject.name
  end
  
  def score_of(student)
    score = scores.select{|score| score.student == student}.first
    if score then return score.score end
  end
  
  def students
#    cannot use klass here, since an exam which is not saved in ExamController.create will also need to use the same method
    students_with_scores + exam_group.klass.students.for_paper(exam_group.klass.papers.find_by_subject_id(subject.id).id)
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
