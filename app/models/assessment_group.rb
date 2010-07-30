class AssessmentGroup < ActiveRecord::Base
  
  belongs_to :klass
  has_one :school, :through => :klass
  belongs_to :assessment_type
  belongs_to :academic_year
  
  has_many :assessments
  
  validates_numericality_of :weightage, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 
  
    
  named_scope :SA, :joins => :assessment_type, :conditions => ["assessment_types.name like ? ", "SA%"]
  named_scope :FA, :joins => :assessment_type, :conditions => ["assessment_types.name like ? ", "FA%"]
  
  named_scope :for_year, lambda {|year|
    {:conditions =>{:academic_year_id => year.id}}
  }
  
  def destroyable?
    assessments.blank?
  end
  
end
