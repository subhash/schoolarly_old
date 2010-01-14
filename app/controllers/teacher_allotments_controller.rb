class TeacherAllotmentsController < ApplicationController
  
  def create
    @teacher_allotment = TeacherAllotment.new(params[:teacher_allotment])
    @teacher_allotment.subject = Subject.find(params[:subject_id])
    @klass = Klass.find(params[:klass_id])
    @teacher_allotment.klass = @klass
    @teacher_allotment.allotment_date = Time.now.to_date
    @teacher_allotment.is_current = true
    @all_subjects = Subject.find(:all)
    if (@teacher_allotment.save)
      respond_to do |format|
        format.js {render :template => 'teacher_allotments/create_success'}
      end 
    else
      respond_to do |format|          
        format.js {render :template => 'teacher_allotments/create_error'}
      end
    end    
  end
  
  def delete
    @allotment = TeacherAllotment.find(params[:id])
    @allotment.is_current = false
    @allotment.save!
    respond_to do |format|
      flash[:notice] = 'Allotment was successfully removed.'
      format.js {render :template => 'teacher_allotments/delete'}
    end 
  end
 
end
