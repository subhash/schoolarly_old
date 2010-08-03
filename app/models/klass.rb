class Klass < ActiveRecord::Base
  
  has_many :papers
  has_many :school_subjects, :through => :papers, :include => :subject, :order => "subjects.name"
  has_one :academic_year, :through => :school 
  after_create :create_assessment_groups
  
  has_many :all_assessment_groups, :class_name => 'AssessmentGroup' 
  has_many :all_assessments, :source => :assessments, :through => :all_assessment_groups 
#  TODO how to do this correctly
  has_many :assessment_groups, :conditions => 'academic_year_id = #{self.academic_year.id}'
  
  has_many :assessments, :through => :assessment_groups 
  
  validate :weightage_summation
  
  accepts_nested_attributes_for :assessment_groups
  
  def weightage_summation  
    puts "in validation "+assessment_groups.collect(&:weightage).sum.to_s
    if assessment_groups.size > 0 
      unless (assessment_groups.collect(&:weightage).sum == 100)
        errors.add(:weightage, "should addup to 100%")
      end
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
    assessment_tool_ids = assessment_groups.collect{|ag|ag.assessments.for_subject(subject)}.flatten.collect(&:assessment_tool_ids).flatten
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
  
  def create_assessment_groups
    AssessmentType.all.each do |at|
      AssessmentGroup.create(:assessment_type => at, :academic_year => academic_year, :weightage => at.weightage, :max_score => at.max_score, :klass => self)
    end    
  end
  
  def destroy_assessment_groups
    assessment_groups.each do |ag|
      if ag.destroyable?
        ag.destroy
      end
    end
  end
  
end
