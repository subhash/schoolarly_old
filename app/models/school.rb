class School < ActiveRecord::Base
  has_one :user, :as => :person
  has_many :klasses , :order => ["level, division"]
  has_many :teachers 
  has_many :students do
    def not_enrolled
      find :all, :conditions => {:klass_id => nil}
    end
  end
  has_many :exam_groups, :through => :klasses
  
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
