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
  has_many :exams, :through => :scores

  def subjects
    return self.papers.collect{|paper| paper.subject}  
  end
  
  def name
    user.name
  end
  
  def email
    return user.email
  end
  
  def exam_groups
    klass.exam_groups.select{|eg| (eg.subjects & self.subjects).any?}.group_by{|eg| eg.klass} if self.klass
  end
  
end
