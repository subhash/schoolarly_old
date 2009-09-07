class Teacher < ActiveRecord::Base
  has_one :user, :as => :person
  belongs_to :school
  has_many :qualifications
end
