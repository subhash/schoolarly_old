class School < ActiveRecord::Base
  has_one :user, :as => :person
  has_many :klasses
  has_many :teachers
  has_many :students
  has_and_belongs_to_many :subjects
  
  after_update :add_roles
  
  def add_roles
    puts 'school adds roles '
    self.user.has_role 'reader', School
    self.user.has_role 'reader', Student
    self.user.has_role 'reader', Teacher    
  end
  
end
