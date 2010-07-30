class Assessment < ActiveRecord::Base
  
  belongs_to :subject
  belongs_to :assessment_group
  has_one :klass, :through => :assessment_group
  has_one :assessment_type, :through => :assessment_group
  has_many :assessment_tools, :dependent => :destroy
  
  has_many :activities, :through => :assessment_tools
  
  validate :weightage_summation
  
  accepts_nested_attributes_for :assessment_tools
  
  named_scope :for_subject, lambda {|subject|
    {:conditions =>{:subject_id => subject.id}}
  }
  
  named_scope :for_year, lambda {|year|
    {:joins => :assessment_group, :conditions => ["assessment_groups.academic_year_id = ?", year.id]}
  }
  
  named_scope :for_type, lambda {|type|
    {:joins => :assessment_group, :conditions => ["assessment_groups.assessment_type_id = ?",type.id]}
  }
  
  def weightage_summation   
    if assessment_tools.size > 0 
      unless (assessment_tools.collect(&:weightage).sum == 100)
        errors.add(:weightage, "should addup to 100%")
      end
    end
  end
  
  def school_subject
    SchoolSubject.find_by_school_id_and_subject_id(klass.school.id, subject_id)
  end
  
  def paper
    klass.papers.find_by_school_subject_id(klass.school.school_subjects.find_by_subject_id(subject.id).id)
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
    name + " - " + subject.name
  end
  
  def current_students
    klass.students.for_paper(paper.id)
  end
  
  def current_participants
   (paper and paper.teacher) ? (current_students + [paper.teacher]) : current_students
  end
  
  def destroyable?
    activities.select{|a|!a.destroyable?}.blank?
  end
  
  def calculated_score_for(student)
    averages = assessment_tools.collect{|t|t.weighted_average_for(student)}
    averages.compact.size == assessment_tools.size ? averages.sum : nil
  end
  
  def max_score
    assessment_type.max_score   
  end
  
end
