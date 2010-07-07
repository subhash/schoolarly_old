class AssessmentType < ActiveRecord::Base
  
  named_scope :SA, lambda { 
    {:conditions => ["name like ? ", "SA%"]}
  }
  
  named_scope :FA, lambda { 
    {:conditions => ["name like ? ", "FA%"]}
  }
  
end
