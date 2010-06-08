class Activity < ActiveRecord::Base
  belongs_to :assessment
  has_many :exams
  
  def description
    if assessment.assessment_type == 'SA'
      "Term "+assessment.term+" Summative Assessment - "+assessment.name
    else
      assessment.activity + " - " + assessment.name
    end
  end
end
