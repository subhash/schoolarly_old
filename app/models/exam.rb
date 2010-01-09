class Exam < ActiveRecord::Base
  belongs_to :exam_group
  belongs_to :subject
  has_many :scores, :dependent => :destroy
  
  has_one :klass, :through => :exam_group
  has_one :exam_type, :through => :exam_group
  
  acts_as_authorizable
end
