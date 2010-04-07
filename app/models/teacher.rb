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
    self.papers.collect{|paper| (paper.klass.id==klass_id) ?  paper.subject : nil}
  end

  has_many :owned_klasses, :class_name => 'Klass'
  has_many :owned_exams, :class_name => 'Exam'
  
  def name
    return !(user.user_profile.nil?) ? user.user_profile.name : user.email
  end
  
  def email
    return user.email
  end
  
  def exams
    owned_exams.select{|e| e.klass.school == self.school}  
  end
  
  def exam_groups
    exams.collect{|exam| exam.exam_group}.uniq.group_by{|eg| eg.klass}
  end
  
end
