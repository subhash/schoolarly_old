class ExamType < ActiveRecord::Base
  has_many :exams
  
  def description
    if assessment_type == 'SA'
      "Term "+term+" Summative Assessment - "+name
    else
      activity + " - " + name
    end
  end
end
