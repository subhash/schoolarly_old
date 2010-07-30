class Klass < ActiveRecord::Base
  
  has_many :papers
  has_many :school_subjects, :through => :papers, :include => :subject, :order => "subjects.name"
  has_one :academic_year, :through => :school 
  after_create :create_assessment_groups
  
  has_many :all_assessment_groups, :class_name => 'AssessmentGroup' 
  
  has_many :all_assessments, :source => :assessments, :through => :all_assessment_groups 
  
  def assessment_groups
    all_assessment_groups.for_year(academic_year)
  end
  
  def assessments
    all_assessments.for_year(academic_year)
  end

  #  
  #  def weightage_of(assessment_type)
  #    all_assessment_groups.for_type(assessment_type).first.weightage if all_assessment_groups.for_type(assessment_type).first
  #  end
  #  
  #  def FA_weightage(term)
  #    assessment_groups.collect{|g| (g.assessment_type.term == term and g.fa?) ? g.weightage : nil}.compact.sum
  ##    assessment_type_ids = assessment_groups.collect{|g| (g.assessment_type.term == term and g.fa?) ? g.assessment_type_id : nil}.compact
  ##    AssessmentGroup.sum(:weightage, :conditions => "klass_id = ? AND assessment_type_id IN (?)", id, assessment_type_ids)
  #	end
  #
  #  def total_weightage(term)
  #    assessment_groups.collect{|g| (g.assessment_type.term == term) ? g.weightage : nil}.compact.sum
  #	end
  
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
      AssessmentGroup.create(:assessment_type => at, :academic_year => academic_year, :weightage => at.weightage, :klass => self)
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
