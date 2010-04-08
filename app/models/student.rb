class Student < ActiveRecord::Base
  
  validates_uniqueness_of :admission_number, :scope => [:school_id]
  validates_uniqueness_of :roll_number , :scope => [:klass_id]
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
    return !(user.user_profile.nil?) ? user.user_profile.name : user.email
  end
  
  def email
    return user.email
  end
  
end
