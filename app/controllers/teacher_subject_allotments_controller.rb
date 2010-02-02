class TeacherSubjectAllotmentsController < ApplicationController
  
  def edit
    @teacher_subject_allotment=TeacherSubjectAllotment.find(params[:id])
    @klasses=@teacher_subject_allotment.subject.klasses.ofSchool(@teacher_subject_allotment.teacher.school.id)
     respond_to do |format|
      format.js {render :template => 'teacher_subject_allotments/edit'}
    end  
  end
  
  def add_klasses
    teacher_subject_allotment=TeacherSubjectAllotment.find(params[:id])
    teacher_subject_allotment.klass_ids = params[:teacher_subject_allotment][:klass_ids].compact.reject(&:blank?)
    @teacher=teacher_subject_allotment.teacher
  end
  
end