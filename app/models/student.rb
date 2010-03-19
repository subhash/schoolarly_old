class Student < ActiveRecord::Base
  
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
  after_update :update_roles
  
  acts_as_authorizable
  
  def add_roles
    puts 'student adds roles'
    self.user.has_role 'reader', School
    self.user.has_role 'reader', Teacher
    self.user.has_role 'reader', Student
    update_roles
  end
  
  def update_roles
    puts 'student updates roles'
    #    self.school.user.has_role 'editor', self if school
  end  
  
  def name
    return !(user.user_profile.nil?) ? user.user_profile.name : user.email
  end
  
  def email
    return user.email
  end
  
end
