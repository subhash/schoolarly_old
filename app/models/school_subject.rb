class SchoolSubject < ActiveRecord::Base
  belongs_to :school
  belongs_to :subject
  
  has_and_belongs_to_many :assessment_tool_names
  
  def name
    subject.name
  end

end