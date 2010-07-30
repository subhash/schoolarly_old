class Klass < ActiveRecord::Base
  
  has_many :papers
  has_many :school_subjects, :through => :papers, :include => :subject, :order => "subjects.name"
  has_one :academic_year, :through => :school
  has_many :all_assessment_groups, :class_name => 'AssessmentGroup' do
    def for_year(academic_year)
      find :all, :conditions => {:academic_year_id => academic_year.id}
    end
    
    def for_type(assessment_type)
      find :all, :conditions => {:assessment_type_id => assessment_type.id}
    end
  end
  
  has_many :all_assessments, :include => [:assessment_group], :source => :assessments, :through => :all_assessment_groups do
    
    def for_year(academic_year)
      find :all, :conditions => ["assessment_groups.academic_year_id = ?", academic_year.id]
    end
    
    def for_type(assessment_type)
      find :all, :conditions => ["assessment_groups.assessment_type_id = ?", assessment_type.id]
    end
    
    def for_subject(subject)
      find :all, :conditions => {:subject_id =>subject.id}
    end
  end
  
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
  
  validates_uniqueness_of :division, :scope => [:school_id, :level_id]
  
  def name
    return level.name + ' ' + division
  end
  
  def can_be_destroyed
    students.empty? and papers.empty? and all_assessments.empty?    
  end
  
  def future_activities_for(subject)
    assessment_tool_ids = all_assessments.for_year(academic_year).for_subject(subject).collect(&:assessment_tool_ids).flatten
    Activity.find(:all, :include => [:event], :conditions => ["assessment_tool_id IN (?) AND event_id IS NOT NULL AND events.start_time > ? ", assessment_tool_ids, Time.zone.now])
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
