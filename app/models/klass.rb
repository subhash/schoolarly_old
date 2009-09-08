class Klass < ActiveRecord::Base
  belongs_to :school
  belongs_to :class_teacher, :class_name => 'Teacher', :foreign_key => 'teacher_id'
  has_many :enrollments, :class_name =>'StudentEnrollment'  
  has_many :students, :through => :enrollments
  has_and_belongs_to_many :subjects
  has_many :teacher_allotments
  has_many :teachers, :through => :teacher_allotments
  has_many :exam_groups
  
  def current_students
    self.enrollments.select{|e| e.current_student}
  end
end
