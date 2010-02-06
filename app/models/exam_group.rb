class ExamGroup < ActiveRecord::Base
  belongs_to :exam_type
  belongs_to :klass
  
  has_many :exams , :dependent => :destroy
  has_many :subjects, :through => :exams
  
#  validates_presence_of :description, :message => "cannot be blank."
#  validates_uniqueness_of :description, :scope => [:klass_id], :message => "of exam group cannot be repeated for the same class."

  def to_s
    return exam_type.description + ' for ' + klass.name
  end
  
  def is_destroyable?
    return self.exams.select{|exam| !exam.scores.empty? }.empty? 
  end
  
end
