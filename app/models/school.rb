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
  belongs_to :academic_year
  
  def subjects_for_klass(klass_id)
    self.papers.select{|paper| (paper.klass.id==klass_id) }.collect{|p| p.subject}
  end
    
  def name
    user.name
  end
  
  def school
    return self
  end
  
  def users
    return teacher_users | student_users | [user]
  end

  def set_academic_year
    now = Time.now()
    academic_year = AcademicYear.find(:first, :conditions => ["start_date <= ? AND end_date >= ?", now,  now])
    if academic_year
      self.academic_year = academic_year
    else
      end_year = (now.month < 5) ? now.year : now.year + 1
      start_year = end_year - 1
      start_date=Date.new(start_year, 5, 1)
      end_date=Date.new(end_year, 4, 30)
      self.build_academic_year(:start_date => start_date, :end_date => end_date) unless academic_year
    end
  end

end
