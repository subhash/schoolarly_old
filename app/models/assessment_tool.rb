class AssessmentTool < ActiveRecord::Base
  
  belongs_to :assessment_tool_type
  belongs_to :assessment
  
end
