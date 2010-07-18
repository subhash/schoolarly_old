class Paper < ActiveRecord::Base
  belongs_to :klass
  has_one :school, :through => :klass
  belongs_to :school_subject
  has_one :subject, :through => :school_subject
  belongs_to :teacher
  
  has_one :school, :through => :klass
  has_and_belongs_to_many :students
  
  validates_presence_of :klass_id, :school_subject_id
  validates_uniqueness_of :school_subject_id, :scope => [:klass_id]
  
  after_create :create_assessments
  before_destroy :destroy_assessments
  
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
      Assessment.create(:assessment_type => at, :academic_year => klass.academic_year, :weightage => at.weightage, :subject => subject, :klass => klass) 
    end
    AssessmentType.SA.each do |at|
      assessment = Assessment.new(:assessment_type => at, :academic_year => klass.academic_year, :weightage => at.weightage, :subject => subject, :klass => klass) 
      assessment_tool =  AssessmentTool.new(:name => "Exam", :weightage => 100)
      assessment_tool.activities << Activity.new(:description => "#{at.name} #{assessment_tool.name} - #{name}", :max_score => at.max_score)
      assessment.assessment_tools << assessment_tool
      assessment.save!
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
    klass.all_assessments.find_all_by_academic_year_id_and_subject_id(klass.academic_year.id, subject.id)
  end
  
  def assessment_tools
    klass.all_assessment_tools.find_all_by_academic_year_id_and_subject_id(klass.academic_year.id, subject.id)
  end
  
  
  def formative_assessments
    assessments.select{|a|a.name.starts_with? "FA"}
  end
  
  def summative_assessments
    assessments.select{|a|a.name.starts_with? "SA"}
  end
  
  
end
