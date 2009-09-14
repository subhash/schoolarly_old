class Parent < ActiveRecord::Base
  belongs_to :student
  has_one :user, :as => :person
end
