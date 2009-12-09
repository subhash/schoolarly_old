class TeacherAllotment < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :subject
  belongs_to :klass
  
  named_scope :current_for_klass, lambda { |klass_id|
    { :conditions => { :klass_id => klass_id , :is_current => true } , :order => "subject_id"}
  }
end
