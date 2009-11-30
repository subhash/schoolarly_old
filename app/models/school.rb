class School < ActiveRecord::Base
  has_one :user, :as => :person
  has_many :klasses do
    def current()
      find :all , :conditions => ['year = ? ', (Klass.maximum :year, :conditions => {:school_id => id})],:order => "level, division"
    end
  end
  has_many :teachers
  has_many :students
  has_and_belongs_to_many :subjects
  
  after_update :update_roles
  
  def add_roles
    puts 'school adds roles'
    self.user.has_role 'reader', School
    self.user.has_role 'reader', Student
    self.user.has_role 'reader', Teacher    
  end
  
  def update_roles
    puts 'school updates roles'
  end
  
end
