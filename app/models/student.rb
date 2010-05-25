class Student < ActiveRecord::Base
  
#  validates_uniqueness_of :admission_number, :scope => [:school_id]
#  validation cannot be activated in the current multiple add students to class scenario
#  validates_uniqueness_of :roll_number , :scope => [:klass_id]
  named_scope :not_enrolled, lambda {
    {:conditions => { :klass_id => nil}}
  }
  
  has_one :user, :as => :person
  belongs_to :school
  belongs_to :klass
  has_and_belongs_to_many :papers
  has_one :parent
  has_many :scores   
  has_one :academic_year, :through => :school
  has_many :exams, :through => :scores
  
  def current_exams
    self.exams.find_by_academic_year_id(self.academic_year.id) #if self.school
  end
  
  accepts_nested_attributes_for :exams

  def subjects
    return self.papers.collect{|paper| paper.subject}  
  end
  
  def name
    user.name
  end
  
  def email
    return user.email
  end
  
end
