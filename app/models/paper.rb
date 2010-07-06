class Paper < ActiveRecord::Base
  belongs_to :klass
  belongs_to :subject
  belongs_to :teacher
  
  has_one :school, :through => :klass
  has_and_belongs_to_many :students
  
  validates_presence_of :klass_id, :subject_id
  validates_uniqueness_of :subject_id, :scope => [:klass_id]
  
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
    AssessmentType.all.each do |at|
      klass.assessments << Assessment.new(:assessment_type => at, :academic_year => klass.academic_year, :weightage => at.weightage, :subject => subject) 
    end
  end
  
  def destroy_assessments
    klass.assessments.find_all_by_subject_id(subject.id).each do |assessment|
      if assessment.destroyable? 
        assessment.destroy 
      end
    end
  end
  
  def assessments
    klass.all_assessments.find_all_by_academic_year_id_and_subject_id(klass.academic_year.id, subject.id)
  end
  
  
  def formative_assessments
    assessments.select {|a| a.assessment_type.name.starts_with? 'FA'}
  end
  
  def summative_assessments
    assessments.select {|a| a.assessment_type.name.starts_with? 'SA'}
  end
  
  
end
