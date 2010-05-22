module ExamsHelper
  
  def message_if_empty_exams
    return 'No exam available'
  end
  
#  def get_entity_exams(entity, exam_group)
#    case entity.class.name
#      when 'Exam' then [entity]
#      when 'Teacher' then entity.exams.select{|exam| exam.exam_group == exam_group}
#      when 'Student' then exam_group.exams.select{|exam| entity.subjects.include?(exam.subject)}
#      else exam_group.exams
#    end
#  end
    
end
