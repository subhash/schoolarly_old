class AssessmentTool < ActiveRecord::Base
  
  belongs_to :assessment
  
  has_one :klass, :through => :assessment
  
  has_many :activities, :dependent => :destroy
  
  validates_presence_of :name
  
  validates_numericality_of :weightage, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  
  validate :ignore_worst_valid
  
  def ignore_worst_valid
    unless (0..activities.size).include?(ignore_worst)
       errors.add("Best of should be in 0.."+activities.size)
    end
  end
  
  def best_of
    activities.size - ignore_worst
  end
  
end
