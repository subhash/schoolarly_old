class Teacher < ActiveRecord::Base
  has_one :user, :as => :person
  belongs_to :school
  has_many :qualifications
  has_many :allotments, :class_name =>'TeacherAllotment' 
  #has_many :klasses, :through => :allotments
  has_many :subjects, :through => :allotments
  has_many :current_allotments, :class_name => 'TeacherAllotment', :conditions => {:is_current => true}
  has_many :current_klasses, :through => :current_allotments, :source => :klass
  has_many :current_subjects, :through => :current_allotments, :source => :subject
end
