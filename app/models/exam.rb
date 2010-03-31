class Exam < ActiveRecord::Base
  belongs_to :exam_group
  belongs_to :subject
  belongs_to :teacher
  has_many :scores, :dependent => :destroy
  
  has_one :klass, :through => :exam_group
  has_one :exam_type, :through => :exam_group
  
  def to_s
    return exam_group.exam_type.description + ' for ' + subject.name
  end
  
  def students
    klass.students.for_subject(subject)
  end
  
  def is_destroyable?
    return self.scores.empty? 
  end
  
end
