class Klass < ActiveRecord::Base
  
  has_many :papers, :include => :subject, :order => "subject.name"
  has_many :subjects, :through => :papers, :order => "name"
  has_many :teachers, :through => :papers, :uniq => true 
  belongs_to :school
  belongs_to :class_teacher, :class_name => 'Teacher', :foreign_key => 'teacher_id'
  has_many :students  do
    def for_subject(subject_id)
      find :all, :include => [:subjects] , :conditions => ['students_subjects.subject_id = ?',subject_id]
    end  
  end
  has_many :exam_groups
  
  validates_uniqueness_of :division, :scope => [:school_id, :level]
  
  def exams
    return (self.exam_groups).collect{|eg| (!eg.exams.empty?)?(eg.exams):(Exam.new(:exam_group_id => eg.id))}.flatten
  end    
  
  def name
    return level.to_s+" "+division
  end
  
  def can_be_destroyed
    students.empty? and papers.empty? and exam_groups.empty?    
  end
end
