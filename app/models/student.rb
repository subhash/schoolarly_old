class Student < ActiveRecord::Base
  has_one :user, :as => :person
  belongs_to :school
  has_many :enrollments, :class_name => 'StudentEnrollment'
  belongs_to :current_enrollment, :class_name => 'StudentEnrollment', :foreign_key => 'current_enrollment_id'
  has_one :klass , :through => :current_enrollment
  has_one :parent
  
end
