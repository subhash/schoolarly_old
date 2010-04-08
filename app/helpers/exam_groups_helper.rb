module ExamGroupsHelper
  
  def message_if_empty_exam_groups
    return 'No exam exists'
  end
  
  def get_show_options(entity)
    options = case entity.class.name
          when 'School'             then [:show_klass, :edit_exam_group, :delete_exam_group, :add_exam, :edit_exam, :delete_exam, :view_scores, :show_teacher]
          when 'Klass'              then [:edit_exam_group, :delete_exam_group, :add_exam, :edit_exam, :delete_exam, :view_scores, :show_teacher]
          when 'Student'            then [:edit_exam, :show_score, :show_teacher]
          when 'Teacher'            then [:show_klass, :add_exam, :edit_exam, :delete_exam, :view_scores]
          when 'Exam'               then [:edit_exam, :view_scores, :show_teacher]
    end
    return options
  end
  
  def get_symbol_for_local(entity)
    return entity.class.name.underscore.downcase.intern
  end
  
end
