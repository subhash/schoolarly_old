class Klass < ActiveRecord::Base
  belongs_to :school
  belongs_to :class_teacher, :class_name => 'Teacher', :foreign_key => 'teacher_id'
end
