class TeacherKlassAllotment < ActiveRecord::Base
  belongs_to :teacher_subject_allotment
  belongs_to :klass
end
