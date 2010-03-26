class Paper < ActiveRecord::Base
  belongs_to :klass
  has_one :school, :through => :klass
  belongs_to :subject
  belongs_to :teacher
  has_and_belongs_to_many :students
  
  validates_uniqueness_of :subject_id, :scope => [:klass_id]
  validates_presence_of :klass_id, :subject_id
  
  def name
    subject.name
  end

  def desc
    klass.name + ' - ' + subject.name
  end
  
end
