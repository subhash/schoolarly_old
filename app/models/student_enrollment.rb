class StudentEnrollment < ActiveRecord::Base
  belongs_to :student
  belongs_to :klass
end
