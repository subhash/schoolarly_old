class Student < ActiveRecord::Base
  
  has_one :user, :as => :person
  belongs_to :school
  has_many :enrollments, :class_name => 'StudentEnrollment'
  has_many :klasses,:through=>:enrollments
  belongs_to :current_enrollment, :class_name => 'StudentEnrollment', :foreign_key => 'current_enrollment_id'
  has_one :current_klass ,:through => :current_enrollment, :source =>:klass
  has_one :parent
  has_many :scores
  
  after_update :update_roles
  
  acts_as_authorizable
  
  def current_subjects
    self.current_enrollment.subjects
  end
  
  def add_roles
    puts 'student adds roles'
    self.user.has_role 'reader', School
    self.user.has_role 'reader', Teacher
    self.user.has_role 'reader', Student
    update_roles
  end
  
  def update_roles
    puts 'student updates roles'
    self.school.user.has_role 'editor', self if school
  end  
  
  def name
    return user.name
  end
  
end
