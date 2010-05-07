class Paper < ActiveRecord::Base
  belongs_to :klass
  belongs_to :subject
  belongs_to :teacher
  
  has_one :school, :through => :klass
  has_and_belongs_to_many :students
  
  validates_presence_of :klass_id, :subject_id
  validates_uniqueness_of :subject_id, :scope => [:klass_id]
  
  def name
    subject.name
  end

  def desc
    klass.name + ' - ' + subject.name
  end
  
end
