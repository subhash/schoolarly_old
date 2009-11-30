class Subject < ActiveRecord::Base
  has_and_belongs_to_many :schools
  has_and_belongs_to_many :klasses
  has_many :exams
  has_and_belongs_to_many :student_enrollments
  
#  def current_subject_klasses(school_id)
#    return self.klasses.find(:all, :conditions => ["year=?",Klass.current_academic_year(school_id)])
#  end
  
end
