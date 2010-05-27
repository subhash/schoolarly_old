class ExamsController < ApplicationController
  
  protect_from_forgery :only => [:create, :update, :destroy]
  
  def get_entity(entity_class,entity_id)
    Object.const_get(entity_class).find(entity_id)
  end
  
  def show
    @exam=Exam.find(params[:id])
    @exams = [@exam]
  end
  
  #  def new
  #    @exam_group = ExamGroup.find(params[:exam_group])
  #    @exam = Exam.new(:exam_group => @exam_group)
  #    @event = Event.new(:start_time => Time.now, :end_time => 1.hour.from_now, :period => "Does not repeat")
  #    @exam.event = @event   
  #    entity_class = params[:entity_class]
  #    @entity = get_entity(entity_class,params[:entity_id])
  #    #TODO page context
  #    if entity_class == 'Teacher' || entity_class == 'School'
  #      @subjects = @entity.subjects_for_klass(@exam_group.klass.id) - @exam_group.subjects
  #    else
  #      @subjects = @entity.subjects - @exam_group.subjects      
  #    end
  #    #TODO page context
  #    @teachers = (entity_class == 'School')? @entity.teachers : @entity.school.teachers
  
  #  end
  
  #  def create
  #    @exam = Exam.new(params[:exam])
  #    @exam_group=ExamGroup.find(params[:exam_group_id])
  #    @exam.exam_group=@exam_group
  #    @exam.teacher = @exam_group.klass.papers.find_by_subject_id(@exam.subject.id).teacher
  #    @event = Event.new( :title => @exam.to_s, :description => @exam.to_s, :owner => current_user)
  #    @event.attributes = params[:event]
  #    @exam.participants.each do |participant|
  #      @event.users << participant.user
  #    end
  #    @exam.event = @event
  #    @event.save!
  #    @entity = get_entity(params[:entity_class],params[:entity_id])
  #    if @exam.save!
  #      render :template => 'exams/create_success'
  #    else
  #      @subjects = Subject.find(params[:subjects])
  #      render :template => 'exams/create_failure'
  #    end
  #  end
  
  def edit
    @exam = Exam.find(params[:id])
    @exam.event = Event.new( :start_time => Event.now, :end_time => Event.now.advance(:hours => 1 )) unless @exam.event
    @teachers = @exam.school.teachers
  end
  
  def update
    @exam = Exam.find(params[:id])
    @exam.attributes = params[:exam]
    if @exam.event.new_record?
      @event_series = EventSeries.new(:title => @exam.long_desc, :description => @exam.description, :owner => current_user)
      @exam.participants.each do |participant|
        @event_series.users << participant.user
      end
      @exam.event.event_series = @event_series
    end
    if @exam.save!
      render :template => 'exams/update_success'
    else
      render :template => 'exams/update_failure'
    end 
  end
  
  def destroy
    @exam = Exam.find(params[:id])
    if  @exam.destroy
      render :template => 'exams/destroy_success'
    else
      render :template => 'exams/destroy_failure'
    end
  end  
  
end