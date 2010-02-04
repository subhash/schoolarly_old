class TeacherSubjectAllotment < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :school
  belongs_to :subject
  has_many :teacher_klass_allotments
  has_many :current_klass_allotments, :class_name => 'TeacherKlassAllotment', :conditions => [' end_date IS NULL ' ]
  has_many :klasses, :through => :teacher_klass_allotments, :class_name => 'Klass'
  has_many :current_klasses, :through => :current_klass_allotments, :source => :klass
end