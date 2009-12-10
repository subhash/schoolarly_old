class ExamGroupsController < ApplicationController
  
  def destroy
    @active_tab = :Exams
    exam_group=ExamGroup.find(params[:id])
    @klass=exam_group.klass
    div_name=@klass.id.to_s + '_content_table'
    Exam.delete(exam_group.exams)
    exam_group.save!
    exam_group.destroy
    respond_to do |format|
      flash[:notice] = 'Exam group was successfully removed.'
      format.js {render :template => 'exam_groups/destroy'}
    end 
  end
  
  def create
    @klass=Klass.find(params[:id])
    @exam_group=ExamGroup.new()
    @exam_group.exam_type=ExamType.find(params[:exam_type])
    @exam_group.description=params[:description]
    @klass.exam_groups << @exam_group
    @klass.save!
    respond_to do |format|
      flash[:notice] = 'Exam group was successfully created.'
      format.js {render :template => 'exam_groups/create_success'}
    end 
  rescue Exception => e
    respond_to do |format|
      format.js {render :template => 'exam_groups/create_error'}
    end 
  end

  def update
    @exam_group=ExamGroup.find(params[:id])
    @exam_group.exam_type=ExamType.find(params[:exam_type])
    @exam_group.description=params[:description]
    @exam_group.save!
    respond_to do |format|
      flash[:notice] = 'Exam group was successfully updated.'
      format.js {render :template => 'exam_groups/update_success'}
    end 
  rescue Exception => e
    respond_to do |format|
      format.js {render :template => 'exam_groups/update_error'}
    end 
  end  
  
  def show
    @exam_group=ExamGroup.find(params[:id])
    @subjects=Subject.find(:all)
    @exams=@exam_group.exams.group_by{|e| e.exam_group}
    render :update do |page|
      page.replace_html("exams_index_div", :partial => "exams/exams", :object => @exams)
    end      
  end
  
end
