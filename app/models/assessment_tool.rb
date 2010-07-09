class AssessmentTool < ActiveRecord::Base

  belongs_to :assessment
  
  has_one :klass, :through => :assessment
  
  has_many :activities

end
