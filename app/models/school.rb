class School < ActiveRecord::Base
  has_one :user, :as => :person
  has_many :klasses
  has_many :teachers
  has_many :students
  has_and_belongs_to_many :subjects
end
