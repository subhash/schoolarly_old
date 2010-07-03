class Subject < ActiveRecord::Base
  # has_and_belongs_to_many :schools
  #  not sure if this relationship will be needed
  #  has_many :papers
  validates_uniqueness_of :name
end
