module ScoresHelper
  
  def weightage_for_type_in_klass(type, klass)
    klass.assessment_groups.for_type(type).first.weightage
  end
  
  def score_display(score)
    case score.score
      when 'N'
        'N'
      when 'A'
      'A'
    else
      "#{trim(score.score)}/#{trim(score.max_score)}"
    end
  end
  
end
class JavascriptFunction
  
  def initialize(name)
    @func = name
  end
  def to_json(options = {})
    @func
  end
end