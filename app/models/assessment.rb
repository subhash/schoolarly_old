class Assessment < ActiveRecord::Base
  
  belongs_to :klass
  belongs_to :subject
  belongs_to :assessment_type
  belongs_to :academic_year
  belongs_to :teacher
  
  has_many :assessment_tools
  
  def name
    assessment_type.name 
  end
  
  def sa?
    name.starts_with? "SA"
  end
  
end
