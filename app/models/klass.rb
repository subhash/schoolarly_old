class Klass < ActiveRecord::Base
  
  has_many :papers, :include => :subject, :order => "subjects.name"
  has_many :subjects, :through => :papers, :order => "name"
  has_many :teachers, :through => :papers, :uniq => true 
  belongs_to :school
  belongs_to :level
  belongs_to :class_teacher, :class_name => 'Teacher', :foreign_key => 'teacher_id'
  has_many :students , :dependent => :nullify do
    def for_paper(paper_id)
      find :all, :include => [:papers], :conditions => ['papers_students.paper_id = ?',paper_id]
    end  
  end
  has_many :student_users, :through => :students, :source => :user
  has_many :exams, :include => [:activity, :event],  :order => "activity_id" do
    def future_for(subject_id)
      find :all, :conditions => ["event_id IS NOT NULL AND events.end_time > ? AND subject_id = ?", Time.zone.now, subject_id]
    end
  end
  
  has_many :activities, :through => :exams, :uniq => true
  has_one :academic_year, :through => :school
  
  validates_uniqueness_of :division, :scope => [:school_id, :level_id]
  
  accepts_nested_attributes_for :exams
  
  def name
    return level.name + ' ' + division
  end
  
  def can_be_destroyed
    students.empty? and papers.empty? and exams.empty?    
  end
  
  def current_exams
    exams.find_all_by_academic_year_id(academic_year.id)
  end
  
  def current_exams_for(assessment, subject)
     exams.find_all_by_academic_year_id_and_subject_id(academic_year.id, subject.id).select{|e|e.assessment == assessment}
  end
  
  def teacher_users
    teachers=self.teachers
    teachers += [class_teacher] if class_teacher && !teachers.include?(class_teacher)
    return teachers.collect{|t| t.user}
  end
  
  def users
    return teacher_users + student_users
  end
  
end
