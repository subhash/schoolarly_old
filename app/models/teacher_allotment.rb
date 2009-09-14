class TeacherAllotment < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :subject
  belongs_to :klass
end
