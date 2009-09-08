class Exam < ActiveRecord::Base
  belongs_to :exam_group
  belongs_to :subject
  
  has_one :klass, :through => :exam_group
end
