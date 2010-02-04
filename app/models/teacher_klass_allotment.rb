class TeacherKlassAllotment < ActiveRecord::Base
  belongs_to :teacher_subject_allotment
  belongs_to :klass
  
  validates_presence_of :teacher_subject_allotment
  validates_presence_of :klass
  
end
