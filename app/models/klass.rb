class Klass < ActiveRecord::Base
  named_scope :current_klasses, lambda { |school_id, year|
    { :conditions => { :school_id => school_id , :year => year } , :order => "level, division"}
  }
  has_many :teacher_klass_allotments
  #has_many :current_klass_allotments, :through => :teacher_klass_allotments, :conditions => [' end_date is not null ' ]
  belongs_to :school
  belongs_to :class_teacher, :class_name => 'Teacher', :foreign_key => 'teacher_id'
  has_many :enrollments, :class_name =>'StudentEnrollment' do
    def for_subject(subject_id)
      find :all, :include => [:subjects] , :conditions => ['student_enrollments_subjects.subject_id = ?',subject_id]
    end
  end
  has_many :students, :through => :enrollments  
  has_and_belongs_to_many :subjects, :order => "name"
  has_many :exam_groups
  
  validates_uniqueness_of :division, :scope => [:school_id, :level, :year]
  
  def exams
    return (self.exam_groups).collect{|eg| (!eg.exams.empty?)?(eg.exams):(Exam.new(:exam_group_id => eg.id))}.flatten
  end
#  To show students that are presently in the class
#   For ex. some students may get transferred mid-year - they're not shown in this query
  def current_students
   (self.enrollments.select{|e| e.current_student}).collect{|s|s.student}
 end
 
 def students_studying(subject_id)
   self.enrollments.for_subject(subject_id).collect{|e|e.student}
 end
  
  def current_student_ids
   (self.enrollments.select{|e| e.current_student}).collect{|s|s.student.id}
  end
  
  def self.current_academic_year(school_id)
    return Klass.maximum(:year, :conditions => {:school_id => school_id})
  end
  
  def current_academic_year
    return self.current_academic_year(school.id)
  end
  
  def name
    return level.to_s+" "+division
  end
  
  def allotted_subjects
    return teacher_klass_allotments.collect{|ka| ka.teacher_subject_allotment.subject.id}
  end
  
  def can_be_destroyed
    students.empty? and allotted_subjects.empty? and exam_groups.empty?    
  end
end
