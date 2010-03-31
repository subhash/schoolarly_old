class School < ActiveRecord::Base
  has_one :user, :as => :person
  has_many :klasses , :order => ["level, division"]
  has_many :teachers 
  has_many :students do
    def not_enrolled
      find :all, :conditions => {:klass_id => nil}
    end
  end
  has_many :exam_groups, :through => :klasses
  has_many :papers, :through => :klasses
  has_many :unallotted_papers, :source => :papers, :through => :klasses, :conditions => ['papers.teacher_id IS NULL']

  def subjects_for_klass(klass_id)
    self.papers.collect{|paper| (paper.klass.id==klass_id) ?  paper.subject : nil}
  end
  
end
