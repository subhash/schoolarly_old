class School < ActiveRecord::Base
  has_one :user, :as => :person
  has_many :klasses , :order => ["level_id, division"]
  has_many :teachers 
  has_many :teacher_users, :through => :teachers, :source => :user
  has_many :students do
    def not_enrolled
      find :all, :conditions => {:klass_id => nil}
    end
  end
  has_many :student_users, :through => :students, :source => :user
  has_many :exams, :through => :klasses
  has_many :papers, :through => :klasses
  has_many :unallotted_papers, :source => :papers, :through => :klasses, :conditions => ['papers.teacher_id IS NULL']

  def subjects_for_klass(klass_id)
    self.papers.select{|paper| (paper.klass.id==klass_id) }.collect{|p| p.subject}
  end
    
  def name
    user.name
  end
  
#  def exams
#    self.exam_groups.collect{|eg| eg.exams}.flatten
#  end
  
  def school
    return self
  end
  
  def users
    return teacher_users + student_users + [user]
  end

end
