class ExamsController < ApplicationController
  
  protect_from_forgery :only => [:create, :update, :destroy]

  def show
    @exam=Exam.find(params[:id])
    add_breadcrumb(@exam.exam_group.klass.school.name, @exam.exam_group.klass.school)
    add_breadcrumb(@exam.exam_group.klass.name, @exam.exam_group.klass)
    add_breadcrumb(@exam.to_s)
    @exams=[@exam].group_by{|e| e.exam_group}
  end
  
  def new
    @exam_group = ExamGroup.find(params[:exam_group])
    @exam = Exam.new(:exam_group => @exam_group)
    respond_to do |format|
      format.js {render :template => 'exams/new'}
    end  
  end
  
  def create
    @exam = Exam.new(params[:exam])
    @exam.exam_group=ExamGroup.find(params[:exam_group_id])
    @exam.save!
    respond_to do |format|
      flash[:notice] = 'Exams were successfully created.'
      format.js {render :template => 'exams/create_success'}
    end 
  rescue Exception => e
    respond_to do |format|
      format.js {render :template => 'exams/create_error'}
    end 
  end
  
  def edit
    @exam = Exam.find(params[:id])
    respond_to do |format|
      format.js {render :template => 'exams/edit'}
    end  
  end
  
  def update
    @exam=Exam.find(params[:id])
    if params
      @exam.update_attributes!(params[:exam])
    end
    respond_to do |format|
      format.js {render :template => 'exams/update_success'}
    end 
  rescue Exception => e
    respond_to do |format|
      format.js {render :template => 'exams/update_error'}
    end
  end
  
  def destroy
    exam = Exam.find(params[:id])
    @exam_group=exam.exam_group
    exam.destroy
    respond_to do |format|
      flash[:notice] = 'Exam was successfully removed.'
      format.js {render :template => 'exams/destroy'}
    end 
  end  
  
end