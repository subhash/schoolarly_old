class ExamsController < ApplicationController
  
  protect_from_forgery :only => [:create, :update, :destroy]

  def get_entity(entity_class,entity_id)
    Object.const_get(entity_class).find(entity_id)
  end

  def show
    @exam=Exam.find(params[:id])
    add_breadcrumb(@exam.klass.school.name, @exam.klass.school)
    add_breadcrumb(@exam.klass.name, @exam.klass)
    add_breadcrumb(@exam.to_s)
    @exams = [@exam]
  end
  
  def new
    @exam_group = ExamGroup.find(params[:exam_group])
    @exam = Exam.new(:exam_group => @exam_group)
    entity_class = params[:entity_class]
    @entity = get_entity(entity_class,params[:entity_id])
    if entity_class == 'Teacher' || entity_class == 'School'
      @subjects = @entity.subjects_for_klass(@exam_group.klass.id) - @exam_group.subjects
    else
      @subjects = @entity.subjects - @exam_group.subjects      
    end
  end
  
  def create
    @exam = Exam.new(params[:exam])
    @exam_group=ExamGroup.find(params[:exam_group_id])
    @exam.exam_group=@exam_group
    @exam.teacher=Paper.find_by_klass_id_and_subject_id(@exam_group.klass.id, @exam.subject_id).teacher
    @entity = get_entity(params[:entity_class],params[:entity_id])
    @exam.save!
    render :template => 'exams/create_success'
  rescue Exception => e
    @subjects = Subject.find(params[:subjects])
    render :template => 'exams/create_failure'
  end
  
  def edit
    @exam = Exam.find(params[:id])
    @entity = get_entity(params[:entity_class],params[:entity_id])
  end
  
  def update
    @exam=Exam.find(params[:id])
    @entity = get_entity(params[:entity_class],params[:entity_id])
    if params
      @exam.update_attributes!(params[:exam])
    end
    render :template => 'exams/update_success'
  rescue Exception => e
    render :template => 'exams/update_failure'
  end
  
  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy
  end  
  
end