class School < ActiveRecord::Base
  has_one :user, :as => :person
  has_many :klasses
  has_many :teachers
  has_many :students
end
