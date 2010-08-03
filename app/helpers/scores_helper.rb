module ScoresHelper
  
  def weightage_for_type_in_klass(type, klass)
    klass.assessment_groups.for_type(type).first.weightage
  end
end
