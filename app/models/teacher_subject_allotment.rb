class TeacherSubjectAllotment < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :school
  belongs_to :subject
  has_many :teacher_klass_allotments
  has_many :klasses, :through => :teacher_klass_allotments, :class_name => 'Klass'
end