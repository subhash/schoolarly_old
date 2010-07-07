class AssessmentToolName < ActiveRecord::Base
  
  belongs_to :school_subject
  has_one :subject, :through => :school_subject
  has_one :school, :through => :school_subject
    
  named_scope :SA, lambda { 
    {:conditions => {:assessment_type_name => "SA"}}
  }
  
  named_scope :FA, lambda { 
    {:conditions => {:assessment_type_name => "FA"}}
  }
  
end
