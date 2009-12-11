class ExamsController < ApplicationController
  
  protect_from_forgery :only => [:create, :update, :destroy]
  
   def update_exam
    @exam=Exam.find(params[:id])
    if params
      update_params=params.reject{|key,value| !["subject_id","start_time","end_time","venue","max_score","pass_score"].include?(key) }
      @exam.update_attributes!(update_params)
    end
    respond_to do |format|
      flash[:notice] = 'Exam details were successfully updated.'
      format.js {render :template => 'exams/update_success'}
    end 
  rescue Exception => e
    respond_to do |format|
      flash[:notice]=e.message
      format.js {render :template => 'exams/update_error'}
    end
  end
  
  def create_exam
    exam_group=ExamGroup.find(params[:id])
    @exam=Exam.new()
    @exam.subject=Subject.find(params[:subject])
    @exam.start_time=params[:start_time]
    @exam.end_time=params[:end_time]
    @exam.venue=params[:venue]
    @exam.max_score=params[:max_score]
    @exam.pass_score=params[:pass_score]
    exam_group.exams << @exam
    exam_group.save!
    respond_to do |format|
      flash[:notice] = 'Exam was successfully created.'
      format.js {render :template => 'exams/create_success'}
    end 
  rescue Exception => e
    respond_to do |format|
      format.js {render :template => 'exams/create_error'}
    end 
  end  
  
  def destroy_exam
    exam = Exam.find(params[:id])
    @exam_group=exam.exam_group
    exam.destroy
    respond_to do |format|
      flash[:notice] = 'Exam was successfully removed.'
      format.js {render :template => 'exams/destroy'}
    end 
  end
end