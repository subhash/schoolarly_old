class AssessmentTool < ActiveRecord::Base
  
  belongs_to :assessment
  
  has_one :klass, :through => :assessment
  
  has_many :activities, :dependent => :destroy
  
  validates_presence_of :name
  
  validates_numericality_of :weightage, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  
  validate_on_update :best_of_valid
  
  def best_of_valid
    unless (1..activities.size).include?(best_of)
       errors.add("Best of should be in 1..#{activities.size}")
    end
  end
    
end
