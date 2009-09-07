class Student < ActiveRecord::Base
  has_one :user, :as => :person
  belongs_to :school
  has_one :enrollment, :class_name => "StudentEnrollment"
end
