class Klass < ActiveRecord::Base
  belongs_to :school
  belongs_to :class_teacher, :class_name => 'Teacher', :foreign_key => 'teacher_id'
  has_many :current_enrollments, :class_name => 'StudentEnrollment'
  has_many :students, :through => :current_enrollments
end
