class ExamGroup < ActiveRecord::Base
  belongs_to :exam_type
  belongs_to :klass
  
  has_many :exams
end
