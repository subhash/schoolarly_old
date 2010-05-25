class Teacher < ActiveRecord::Base
  has_one :user, :as => :person
  belongs_to :school
  
  has_many :papers
  has_many :klasses, :through => :papers, :uniq => true do
    def for_subject(subject_id)
      find :all , :conditions => ['papers.subject_id = ?', subject_id]
    end
  end
  has_many :subjects, :through => :papers, :uniq => true, :order => 'name'
  
  def subjects_for_klass(klass_id)
    self.papers.select{|paper| (paper.klass.id==klass_id) }.collect{|p| p.subject}
  end

  has_many :owned_klasses, :class_name => 'Klass'
  has_one :academic_year, :through => :school
  has_many :exams
  
  def current_exams
    self.exams.find_by_academic_year_id(self.academic_year.id) #if self.school
  end
  
  accepts_nested_attributes_for :exams
  
  def name
    user.name
  end
  
  def email
    return user.email
  end
  
end
