class Paper < ActiveRecord::Base
  belongs_to :klass
  belongs_to :subject
  belongs_to :teacher
  
  validates_uniqueness_of :subject, :scope => [:klass_id]
  validates_presence_of :klass, :subject
end
