class TeacherKlassAllotmentsController < ApplicationController

  def allot_teacher_new
    @subject = Subject.find(params[:subject])
    @klass = Klass.find(params[:klass])
    respond_to do |format|
      format.js {render :template => 'teacher_klass_allotments/allot_teacher_new'}
    end
  end
  
  def allot_teacher
    @teacher_klass_allotment = TeacherKlassAllotment.new(:klass_id => params[:klass_id])
    @klass = Klass.find(params[:klass_id])
    teacher_subject_allotment = TeacherSubjectAllotment.find(:first, :conditions => ["teacher_id = ? and subject_id = ?", params[:teacher_id], params[:subject_id]])
    @teacher_klass_allotment.teacher_subject_allotment = teacher_subject_allotment
    @teacher_klass_allotment.klass = @klass
    @teacher_klass_allotment.start_date = Time.now.to_date
    @all_subjects = Subject.find(:all)
    if (@teacher_klass_allotment.save)
      respond_to do |format|
        format.js {render :template => 'teacher_klass_allotments/allot_teacher_success'}
      end 
    else
      respond_to do |format|          
        format.js {render :template => 'teacher_klass_allotments/allot_teacher_error'}
      end
    end    
  end

end
