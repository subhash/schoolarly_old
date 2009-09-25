class Exam < ActiveRecord::Base
  belongs_to :exam_group
  belongs_to :subject
  has_many :scores
  
  has_one :klass, :through => :exam_group
  
  acts_as_authorizable
end
