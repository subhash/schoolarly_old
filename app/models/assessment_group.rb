class AssessmentGroup < ActiveRecord::Base
  
  belongs_to :klass
  has_one :school, :through => :klass
  belongs_to :assessment_type
  belongs_to :academic_year
  
  has_many :assessments
  
  validates_numericality_of :weightage, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 
  
end
