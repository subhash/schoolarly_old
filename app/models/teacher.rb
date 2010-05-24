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
  
  has_many :exams do
    def of_year(academic_year)
      find :all, :include => :event, :conditions => ['exams.academic_year_id = ?', academic_year.id], :order => "exams.klass_id, exams.exam_type_id"
    end
  end
  
  def current_academic_year
    self.school.academic_year if self.school
  end
  
  def current_exams
    self.exams.of_year(self.current_academic_year) if self.school
  end
  
  accepts_nested_attributes_for :exams
  
  def name
    user.name
  end
  
  def email
    return user.email
  end
  
end
