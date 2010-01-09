class StudentEnrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :klass
  has_one :current_student, :class_name => 'Student', :foreign_key => 'current_enrollment_id', :dependent => :nullify
  has_and_belongs_to_many :subjects, :order => "name"
end
