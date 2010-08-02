module ScoresHelper
  
  def weightage_for_type_in_klass(type, klass)
    klass.all_assessment_groups.for_year(klass.academic_year).for_type(type).first.weightage
  end
end
