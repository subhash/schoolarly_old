class AssessmentType < ActiveRecord::Base
  
  named_scope :SA, lambda { 
    {:conditions => ["name like ? ", "SA_"]}
  }
  
  named_scope :FA, lambda { 
    {:conditions => ["name like ? ", "FA_"]}
  }
  
end
