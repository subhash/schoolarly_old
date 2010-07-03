class AssessmentToolType < ActiveRecord::Base
  
  belongs_to :school_subject
  belongs_to :assessment_type
  
end
