class Assessment < ActiveRecord::Base
  
  belongs_to :klass
  has_one :school, :through => :klass
  belongs_to :subject
  belongs_to :assessment_type
  belongs_to :academic_year
  belongs_to :teacher
  
  has_many :assessment_tools
  
  has_many :activities, :through => :assessment_tools
  
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
  
  def students
    klass.students.for_paper(paper.id)
  end
  
  def participants
    teacher ? (students + [teacher]) : students
  end
  
end
