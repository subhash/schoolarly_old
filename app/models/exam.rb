class Exam < ActiveRecord::Base
  belongs_to :exam_group
  belongs_to :subject
  belongs_to :teacher
  has_many :scores, :dependent => :destroy
  has_many :students_with_scores, :through => :scores, :source => :student
  has_one :klass, :through => :exam_group
  has_one :exam_type, :through => :exam_group
  
  def to_s
    return exam_group.exam_type.description + ' for ' + subject.name
  end
  
  def score_of(student)
    score = scores.select{|score| score.student == student}.first
    if score then return score.score end
  end
  
  def students
    students_with_scores + klass.students.for_paper(klass.papers.for_subject(subject.id).id)
  end
  
  def is_destroyable?
    return self.scores.empty? 
  end
  
end
