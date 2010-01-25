class ExamGroupsController < ApplicationController
  
  def create
    @exam_group=ExamGroup.new(params[:exam_group])
    @klass=@exam_group.klass
    @exam_group.subject_ids = params[:exam][:subject_ids]
    @exam_group.save!
    respond_to do |format|
      flash[:notice] = 'Exams were successfully created.'
      format.js {render :template => 'exam_groups/create_success'}
    end 
  rescue Exception => e
    respond_to do |format|
    flash[:notice] = 'Error: ' + e.message
      format.js {render :template => 'exam_groups/create_error'}
    end 
  end 
 
  def update
    @exam_group=ExamGroup.find(params[:id])
    @exam_group.update_attributes!(params[:exam_group])
    @exam_group.save!
    respond_to do |format|
      format.js {render :template => 'exam_groups/update_success'}
    end 
  rescue Exception => e
    respond_to do |format|
      flash[:notice] = 'Error:' + e.message
      format.js {render :template => 'exam_groups/update_error'}
    end
  end  
  
  def destroy
    @active_tab = :Exams
    exam_group=ExamGroup.find(params[:id])
    @klass=exam_group.klass
    Exam.delete(exam_group.exams)
    exam_group.save!
    exam_group.destroy
    respond_to do |format|
      flash[:notice] = 'Exam group was successfully removed.'
      format.js {render :template => 'exam_groups/destroy'}
    end 
  end
  
end
