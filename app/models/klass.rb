class Klass < ActiveRecord::Base
  belongs_to :school
  belongs_to :class_teacher, :class_name => 'Teacher', :foreign_key => 'teacher_id'
  has_many :enrollments, :class_name =>'StudentEnrollment'  
  has_many :students, :through => :enrollments
  has_many :current_students,:through => :enrollments, :source=>:student
  has_and_belongs_to_many :subjects
end
