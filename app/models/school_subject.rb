class SchoolSubject < ActiveRecord::Base
  belongs_to :school
  belongs_to :subject
  
  has_many :assessment_tool_types
  
  def name
    subject.name
  end
end