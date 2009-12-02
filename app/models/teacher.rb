class Teacher < ActiveRecord::Base
  has_one :user, :as => :person
  belongs_to :school
  has_many :qualifications
  has_many :allotments, :class_name =>'TeacherAllotment' 
  #has_many :klasses, :through => :allotments
  has_many :subjects, :through => :allotments
  has_many :current_allotments, :class_name => 'TeacherAllotment', :conditions => {:is_current => true}, :order => "subject_id"
  has_many :current_klasses, :through => :current_allotments, :source => :klass do
    def teaches(subject_id)
      find :all, :conditions => ['subject_id = ? ', subject_id], :order => "level, division"
    end
  end
  has_many :current_subjects, :through => :current_allotments, :source => :subject, :uniq => true
  has_many :owned_klasses, :class_name => 'Klass'
  def currently_owned_klasses
    return owned_klasses.find(:all, :conditions => ["year=?",Klass.current_academic_year(self.school_id)])
  end
  
  def add_roles
    puts 'teacher add roles'
    self.user.has_role 'reader', School
    self.user.has_role 'reader', Teacher
    self.user.has_role 'reader', Student
  end
end
