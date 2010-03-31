class Student < ActiveRecord::Base
  
  named_scope :not_enrolled, lambda {
    {:conditions => { :klass_id => nil}}
  }
  
  has_one :user, :as => :person
  belongs_to :school
  belongs_to :klass
  has_and_belongs_to_many :papers
  has_one :parent
  has_many :scores   
  has_many :exams, :through => :scores

  def subjects
    return self.papers.collect{|paper| paper.subject}  
  end
  
  def name
    return !(user.user_profile.nil?) ? user.user_profile.name : user.email
  end
  
  def email
    return user.email
  end
  
end
