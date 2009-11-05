class Parent < ActiveRecord::Base
  belongs_to :student
  has_one :user, :as => :person
  
  def add_roles
    puts 'parent adds roles'
    self.user.has_role 'reader', School
    self.user.has_role 'reader', Teacher
    self.user.has_role 'reader', Student
  end
end
