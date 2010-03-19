class Klass < ActiveRecord::Base
  
  has_many :papers
  has_many :subjects, :through => :papers, :order => "name"
  has_many :teachers, :through => :papers, :uniq => true 
  belongs_to :school
  belongs_to :class_teacher, :class_name => 'Teacher', :foreign_key => 'teacher_id'
  has_many :students  do
    def for_subject(subject_id)
      find :all, :include => [:subjects] , :conditions => ['student_subjects.subject_id = ?',subject_id]
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
  
  def allotted_papers
    return papers.collect{|p| p.teacher}
  end
  
  def can_be_destroyed
    students.empty? and allotted_papers.empty? and exam_groups.empty?    
  end
  
end
