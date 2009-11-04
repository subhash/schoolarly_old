class ExamGroup < ActiveRecord::Base
  belongs_to :exam_type
  belongs_to :klass
  
  has_many :exams
  
  validates_presence_of :description, :message => "cannot be blank."
  validates_uniqueness_of :description, :scope => [:klass_id], :message => "of exam group cannot be repeated for the same class."
 
end
