class Subject < ActiveRecord::Base
 # has_and_belongs_to_many :schools
  has_and_belongs_to_many :klasses do
    def ofSchool(school_id)
      find :all, :conditions => ['year = ? ', (Klass.maximum :year, :conditions => {:school_id => school_id})], :order => "level, division"
    end
  end
  has_many :exams
  has_and_belongs_to_many :student_enrollments
end
