class TeacherKlassAllotmentsController < ApplicationController

  def create
    @teacher_klass_allotment = TeacherKlassAllotment.new(:klass_id => params[:klass_id])
    @klass = Klass.find(params[:klass_id])
    teacher_subject_allotment = TeacherSubjectAllotment.find(:first, :conditions => ["teacher_id = ? and subject_id = ?", params[:teacher_id], params[:subject_id]])
    @teacher_klass_allotment.teacher_subject_allotment = teacher_subject_allotment
    @teacher_klass_allotment.klass = @klass
    @teacher_klass_allotment.start_date = Time.now.to_date
    @all_subjects = Subject.find(:all)
    if (@teacher_klass_allotment.save)
      respond_to do |format|
        format.js {render :template => 'teacher_klass_allotments/create_success'}
      end 
    else
      respond_to do |format|          
        format.js {render :template => 'teacher_klass_allotments/create_error'}
      end
    end    
  end

end
