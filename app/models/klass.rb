class Klass < ActiveRecord::Base
  
  has_many :papers, :include => :subject, :order => "subjects.name"
  has_many :subjects, :through => :papers, :order => "name"
  has_many :teachers, :through => :papers, :uniq => true 
  #has_many :teacher_users, :through => :teachers, :source => :user, :source_type => 'Person'
  belongs_to :school
  belongs_to :level
  belongs_to :class_teacher, :class_name => 'Teacher', :foreign_key => 'teacher_id'
  has_many :students  do
    def for_paper(paper_id)
      find :all, :include => [:papers] , :conditions => ['papers_students.paper_id = ?',paper_id]
    end  
  end
  has_many :student_users, :through => :students, :source => :user
  has_many :exam_groups
  has_many :exams, :through => :exam_groups
  validates_uniqueness_of :division, :scope => [:school_id, :level_id]
  
  def name
    return level.name + ' ' + division
  end
  
  def can_be_destroyed
    students.empty? and papers.empty? and exam_groups.empty?    
  end
  
  def teacher_users
    teachers=self.teachers
    teachers << class_teacher if class_teacher && !teachers.include?(class_teacher)
    return teachers.collect{|t| t.user}
  end
  
  def users
    return teacher_users + student_users
  end
  
end
