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
  has_many :exams
  
  def name
    return !(user.user_profile.nil?) ? user.user_profile.name : user.email
  end
  
  def email
    return user.email
  end
  
end
