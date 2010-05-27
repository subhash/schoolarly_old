class Paper < ActiveRecord::Base
  belongs_to :klass
  belongs_to :subject
  belongs_to :teacher
  
  has_one :school, :through => :klass
  has_and_belongs_to_many :students
  
  validates_presence_of :klass_id, :subject_id
  validates_uniqueness_of :subject_id, :scope => [:klass_id]
  
  after_create :create_exams
  before_destroy :destroy_exams
  
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
  
  def create_exams
    ExamType.all.each do |et|
      klass.exams << Exam.new(:exam_type => et, :academic_year => klass.academic_year, :description => "", :subject => subject) 
    end
  end
  
  def destroy_exams
    subject.exams.find_all_by_klass_id(klass.id).each do |exam|
      exam.destroy if exam.destroyable?
    end
  end
  
end
