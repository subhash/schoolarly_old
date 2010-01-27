class StudentEnrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :klass
  has_one :current_student, :class_name => 'Student', :foreign_key => 'current_enrollment_id', :dependent => :nullify
  has_and_belongs_to_many :subjects, :order => "name"
  
  def exams
    return Exam.all(:conditions => ["exam_group_id IN (:egid) AND subject_id IN (:sid)", {:egid => self.klass.exam_groups.collect{|eg| eg.id}, :sid => self.subjects}]).flatten
  end
  
end
