class Teacher < ActiveRecord::Base
  has_one :user, :as => :person
  belongs_to :school
  has_many :papers
  has_many :klasses, :through => :papers, :uniq => true 
#  do
#    def for_subject(subject_id)
#      find :all , :conditions => ['papers.subject_id = ?', subject_id]
#    end
#  end
  #has_many :subjects, :through => :papers, :uniq => true, :order => 'name'
  has_many :owned_klasses, :class_name => 'Klass'
  has_one :academic_year, :through => :school, :order => "start_date DESC"
  
  def name
    user.name
  end
  
  def email
    return user.email
  end
  
end
