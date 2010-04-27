class ExamsController < ApplicationController
  
  protect_from_forgery :only => [:create, :update, :destroy]
  
  def get_entity(entity_class,entity_id)
    Object.const_get(entity_class).find(entity_id)
  end
  
  def show
    @exam=Exam.find(params[:id])
    @exams = [@exam]
  end
  
  def new
    @exam_group = ExamGroup.find(params[:exam_group])
    @exam = Exam.new(:exam_group => @exam_group)
    @event = Event.new(:start_time => Time.now, :end_time => 1.hour.from_now, :period => "Does not repeat")
    @exam.event = @event
    entity_class = params[:entity_class]
    @entity = get_entity(entity_class,params[:entity_id])
    #TODO page context
    if entity_class == 'Teacher' || entity_class == 'School'
      @subjects = @entity.subjects_for_klass(@exam_group.klass.id) - @exam_group.subjects
    else
      @subjects = @entity.subjects - @exam_group.subjects      
    end
    #TODO page context
    @teachers = (entity_class == 'School')? @entity.teachers : @entity.school.teachers
  end
  
  def create
    @exam = Exam.new(params[:exam])
    @exam_group=ExamGroup.find(params[:exam_group_id])
    @exam.exam_group=@exam_group
    @event = Event.new( :title => @exam.to_s, :description => @exam.to_s, :owner => current_user)
    @event.attributes = params[:event]
    @exam.students.each do |student|
      @event.users << student.user
    end
    @exam.event = @event
    @event.save!
    @entity = get_entity(params[:entity_class],params[:entity_id])
    if @exam.save!
      render :template => 'exams/create_success'
    else
      @subjects = Subject.find(params[:subjects])
      render :template => 'exams/create_failure'
    end
  end
  
  def edit
    @exam = Exam.find(params[:id])
    #TODO page context
    @entity = get_entity(params[:entity_class],params[:entity_id])
    @teachers = (params[:entity_class] == 'School')? @entity.teachers : @entity.school.teachers
    @teacher_suggestion = @exam.teacher || Paper.find_by_klass_id_and_subject_id(@exam.exam_group.klass.id, @exam.subject_id).teacher
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