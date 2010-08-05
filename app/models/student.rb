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
  has_many :subjects, :through => :papers
  has_one :parent
  has_many :scores   do
    def for_activities(activity_ids) 
      find :all, :conditions => {:activity_id => activity_ids}
    end     
  end
  has_many :activities, :through => :scores
  
  def academic_year
    school.academic_year if school  
  end
  
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
