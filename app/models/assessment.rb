class Assessment < ActiveRecord::Base
  
  belongs_to :klass
  has_one :school, :through => :klass
  belongs_to :subject
  belongs_to :assessment_type
  belongs_to :academic_year
  belongs_to :teacher
  
  has_many :assessment_tools
  
  def school_subject
    SchoolSubject.find_by_school_id_and_subject_id(school.id, subject_id)
  end
  
  def paper
    Paper.find_by_klass_id_and_subject_id(klass.id, subject_id)
  end
  
  def name
    assessment_type.name 
  end
  
  def sa?
    name.starts_with? "SA"
  end
  
  def long_name
    name + " - "+subject.name
  end
  
end
