class Activity < ActiveRecord::Base
  belongs_to :assessment_tool
  belongs_to :event
  
end
