class Activity < ActiveRecord::Base
  belongs_to :assessment_tool
  belongs_to :event
  
  def name
    assessment_tool.name
  end
  
end
