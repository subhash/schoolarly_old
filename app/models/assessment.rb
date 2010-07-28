class Assessment < ActiveRecord::Base
  
  belongs_to :klass
  has_one :school, :through => :klass
  belongs_to :subject
  belongs_to :assessment_type
  belongs_to :academic_year
  belongs_to :teacher
  
  has_many :assessment_tools, :dependent => :destroy
  
  has_many :activities, :through => :assessment_tools
  
  validates_numericality_of :weightage, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 
  
  validate :weightage_summation
  
  accepts_nested_attributes_for :assessment_tools
  
  def weightage_summation   
    if assessment_tools.size > 0 
      unless (assessment_tools.collect(&:weightage).sum == 100)
        errors.add(:weightage, "should addup to 100%")
      end
    end
  end
  
  def school_subject
    SchoolSubject.find_by_school_id_and_subject_id(school.id, subject_id)
  end
  
  def paper
    klass.papers.find_by_school_subject_id(school.school_subjects.find_by_subject_id(subject.id).id)
  end
  
  def name
    assessment_type.name 
  end
  
  def sa?
    name.starts_with? "SA"
  end
  
  def fa?
    name.starts_with? "FA"
  end
  
  def long_name
    name + " - "+subject.name
  end
  
  def current_students
    klass.students.for_paper(paper.id)
  end
  
  def current_participants
    teacher ? (current_students + [teacher]) : current_students
  end
  
  def destroyable?
    activities.select{|a|!a.destroyable?}.blank?
  end
  
end
