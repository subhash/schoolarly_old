class AssessmentType < ActiveRecord::Base
  
  has_many :assessments do
    def current_for_klass(klass)
      find :all, :conditions => {:klass_id => klass.id, :academic_year_id => klass.academic_year.id}
    end
  end
  
  named_scope :SA, lambda { 
    {:conditions => ["name like ? ", "SA%"]}
  }
  
  named_scope :FA, lambda { 
    {:conditions => ["name like ? ", "FA%"]}
  }
  
  named_scope :for_term, lambda {|term|
    {:conditions => ["term = ? ", term]}
  }
  
    
  def self.terms
    find(:all, :select => "DISTINCT term").map(&:term)
  end
  
end
