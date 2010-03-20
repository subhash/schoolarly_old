class Paper < ActiveRecord::Base
  belongs_to :klass
  belongs_to :subject
  belongs_to :teacher
  has_and_belongs_to_many :students
  
  validates_uniqueness_of :subject_id, :scope => [:klass_id]
  validates_presence_of :klass_id, :subject_id
end
