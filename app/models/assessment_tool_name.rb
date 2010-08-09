class AssessmentToolName < ActiveRecord::Base
  belongs_to :school
  has_and_belongs_to_many :school_subjects
    
  named_scope :SA, lambda { 
    {:conditions => {:assessment_type_name => "SA"}}
  }
  
  named_scope :FA, lambda { 
    {:conditions => {:assessment_type_name => "FA"}}
  }
  
  validates_uniqueness_of :name, :scope => [:school_id]
  
end
