class ExamGroup < ActiveRecord::Base
  belongs_to :exam_type
  belongs_to :klass
  
  has_many :exams , :dependent => :destroy
  has_many :subjects, :through => :exams
  
  validates_presence_of :exam_type
#  validates_uniqueness_of :description, :scope => [:klass_id], :message => "of exam group cannot be repeated for the same class."

  def to_s
   exam_type ? (exam_type.description + ' for ' + klass.name) : nil
  end
  
  def is_destroyable?
    return self.exams.select{|exam| !exam.scores.empty? }.empty? 
  end
  
end
