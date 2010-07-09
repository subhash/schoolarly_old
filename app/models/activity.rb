class Activity < ActiveRecord::Base
  belongs_to :assessment_tool
  belongs_to :event
  
  has_one :assessment, :through => :assessment_tool
  
  accepts_nested_attributes_for :event
  
  validates_numericality_of :max_score
  
  def name
    assessment_tool.name
  end
  
end
