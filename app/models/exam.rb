class Exam < ActiveRecord::Base
  belongs_to :exam_group
  belongs_to :subject
  has_many :scores, :dependent => :destroy
  
  has_one :klass, :through => :exam_group
  has_one :exam_type, :through => :exam_group
  
  def to_s
    return self.subject.name + ' ' + exam_group.exam_type.description + ' for ' + exam_group.klass.name + ': ' + exam_group.description 
  end
  
  acts_as_authorizable
  
end
