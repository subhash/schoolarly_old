class Klass < ActiveRecord::Base
  named_scope :current_klasses, lambda { |school_id, year|
    { :conditions => { :school_id => school_id , :year => year } , :order => "level, division"}
  }

  belongs_to :school
  belongs_to :class_teacher, :class_name => 'Teacher', :foreign_key => 'teacher_id'
  has_many :enrollments, :class_name =>'StudentEnrollment'  
  has_many :students, :through => :enrollments
  has_and_belongs_to_many :subjects
  has_many :teacher_allotments do
    def ofTeacher(teacher_id)
      find :all, :conditions => ['teacher_id = ? ', teacher_id]
    end
  end
  has_many :teachers, :through => :teacher_allotments, :uniq => true
	has_many :exam_groups
	
  validates_uniqueness_of :division, :scope => [:school_id, :level, :year]
  
  def current_students
   (self.enrollments.select{|e| e.current_student}).collect{|s|s.student}
  end
  
  def self.current_academic_year(school_id)
    return Klass.maximum :year, :conditions => {:school_id => school_id}
  end
  
  def name
    return level.to_s+" "+division
  end
  
  def subjectsTaughtBy(teacher_id)
    #self.teacher_allotments.select{|a| a.teacher_id == teacher_id}.collect{|s| s.subject}
    self.teacher_allotments.ofTeacher(teacher_id).collect{|s| s.subject}  
  end
  
end
