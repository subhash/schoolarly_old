class Paper < ActiveRecord::Base
  belongs_to :klass
  has_one :school, :through => :klass
  belongs_to :school_subject
  has_one :subject, :through => :school_subject
  belongs_to :teacher

  has_and_belongs_to_many :students
  
  validates_presence_of :klass_id, :school_subject_id
  validates_uniqueness_of :school_subject_id, :scope => [:klass_id]
  
  after_create :create_assessments
  before_destroy :destroy_assessments
  after_save :assign_participants_for_future_activities
  
  def name
    subject.name
  end
  
  def desc
    klass.name + ' - ' + subject.name
  end
  
  def users
    u = students.collect{|s| s.user}
    u << teacher.user if teacher 
    return u
  end
  
  def create_assessments
    AssessmentType.FA.each do |at|
      assessment_group = klass.all_assessment_groups.for_year(klass.academic_year).for_type(at)
      assessment_group = assessment_group ? assessment_group : AssessmentGroup.create(:assessment_type => at, :academic_year => klass.academic_year, :weightage => at.weightage, :klass => klass) 
      Assessment.create(:assessment_group => assessment_group, :subject => subject) 
    end
    AssessmentType.SA.each do |at|
      assessment_group = klass.all_assessment_groups.for_year(klass.academic_year).for_type(at)
      assessment_group = assessment_group ? assessment_group : AssessmentGroup.new(:assessment_type => at, :academic_year => klass.academic_year, :weightage => at.weightage, :klass => klass) 
      assessment = Assessment.new(:assessment_group => assessment_group, :subject => subject) 
      assessment_tool =  AssessmentTool.new(:name => "Exam", :weightage => 100)
      assessment_tool.activities << Activity.new(:description => "#{at.name} #{assessment_tool.name} - #{name}", :max_score => at.max_score)
      assessment.assessment_tools << assessment_tool
      assessment_group.save!
    end
  end
  
  def destroy_assessments
    assessments.each do |assessment|
      if assessment.destroyable? 
        assessment.destroy 
        assessment.activities.each do |activity|
          activity.event.event_series.destroy if activity.event
        end
      end
    end
  end
  
  def assessments
    klass.all_assessments.for_year(academic_year).for_subject(subject)
  end
  
  def formative_assessments
    assessments.select{|a|a.name.starts_with? "FA"}
  end
  
  def summative_assessments
    assessments.select{|a|a.name.starts_with? "SA"}
  end
  
  def assign_participants_for_future_activities
    klass.future_activities_for(subject).each do |activity|
      activity.event.event_series.users = (teacher and activity.event.event_series.owner == teacher) ? (users - [teacher.user]) : users
    end
  end
  
end
