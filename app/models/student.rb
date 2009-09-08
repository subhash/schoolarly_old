class Student < ActiveRecord::Base
  has_one :user, :as => :person
  belongs_to :school
  has_many :enrollments, :class_name => 'StudentEnrollment'
  has_many :klasses,:through=>:enrollments
  belongs_to :current_enrollment, :class_name => 'StudentEnrollment', :foreign_key => 'current_enrollment_id'
  has_one :current_klass ,:through => :current_enrollment, :source =>:klass
  has_one :parent
  
  def current_subjects
    self.current_enrollment.subjects
  end
  
end
