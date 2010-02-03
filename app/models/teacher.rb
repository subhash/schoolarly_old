class Teacher < ActiveRecord::Base
  has_one :user, :as => :person
  belongs_to :school
  
  has_many :teacher_subject_allotments
  has_many :teacher_klass_allotments, :through => :teacher_subject_allotments
  has_many :current_klass_allotments, :through => :teacher_subject_allotments, :source => :teacher_klass_allotments, :conditions => [' end_date is not null ' ]
  has_many :owned_klasses, :class_name => 'Klass'
  
  def current_subject_allotments
    return teacher_subject_allotments.select{|allotment| allotment.school_id == self.school_id}
  end
  
  def klasses(subject_id)
    self.current_subject_allotments.select{|allotment| allotment.subject_id == subject_id}.collect{|alltmnt| alltmnt.klasses}
  end

  def current_subjects
    return current_subject_allotments.collect{|allotment| allotment.subject}
  end
  
  def subject_ids
    return self.current_subjects.collect{|subject| subject.id}
  end
  
  def current_klasses
    return (self.current_subject_allotments.collect{|allotment| allotment.klasses}).flatten
  end

  def currently_owned_klasses
    return owned_klasses.find(:all, :conditions => ["year=?",Klass.current_academic_year(self.school_id)])
  end
  
  def subjects
    return teacher_klass_allotments.collect{|allotment| TeacherSubjectAllotment.all(:conditions => ["id = :tsa_id AND school_id = :school_id", {:tsa_id => allotment.teacher_subject_allotment_id, :school_id => self.school.id}])}.flatten.collect{|sa| sa.subject}.uniq
  end
  
  def allotted_subject_ids
    return self.subjects.collect{|subject| subject.id }
  end
  
  def add_roles
    self.user.has_role 'reader', School
    self.user.has_role 'reader', Teacher
    self.user.has_role 'reader', Student
  end
  
  def name
    return !(user.user_profile.nil?) ? user.user_profile.name : user.email
  end
  
  def email
    return user.email
  end

  def exams
    return current_klass_allotments.collect{|allotment| Exam.all(:conditions => ["exam_group_id IN (:egid) AND subject_id = :sid", {:egid => allotment.klass.exam_groups.collect{|eg| eg.id}, :sid => allotment.teacher_subject_allotment.subject.id}])}.flatten
  end
  
end
