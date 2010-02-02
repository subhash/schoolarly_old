class School < ActiveRecord::Base
  has_one :user, :as => :person
  has_many :klasses do
    def in_year(year)
      find :all , :conditions => ['year = ? ', year],:order => "level, division"
    end
  end
  has_many :teachers 
  has_many :students
  
  def subjects
    return (self.klasses.in_year(Klass.current_academic_year(self.id)).collect{|k| k.subjects}).flatten.uniq
  end
  
  def exam_groups
    return (self.klasses.in_year(Klass.current_academic_year(self.id)).collect{|k| (!k.exam_groups.empty?)?(k.exam_groups):(ExamGroup.new(:klass_id => k.id))}).flatten
  end
  
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
