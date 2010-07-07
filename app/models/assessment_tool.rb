class AssessmentTool < ActiveRecord::Base

  belongs_to :assessment
  
  has_many :activities
end
