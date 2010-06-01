class ExamsController < ApplicationController
  
  protect_from_forgery :only => [:create, :update, :destroy]
  
  def get_entity(entity_class,entity_id)
    Object.const_get(entity_class).find(entity_id)
  end
  
  def show
    @exam=Exam.find(params[:id])
    @exams = [@exam]
  end
 
  def edit
    session[:redirect] = request.request_uri
    @exam = Exam.find(params[:id])
    @exam.event = Event.new( :start_time => Event.now, :end_time => Event.now.advance(:hours => 1 )) unless @exam.event
    @teachers = @exam.school.teachers
  end
  
  def update
    @exam = Exam.find(params[:id])
    @exam.attributes = params[:exam]
    if @exam.event.new_record?
      @event_series = EventSeries.new(:title => @exam.title, :description => @exam.description, :owner => current_user)
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
  
  def add
     @old_exam = Exam.find(params[:id])
     @exam = Exam.new(@old_exam.attributes)
     @exam.description = ""
     @exam.event = nil
     @exam.save
  end
  
  def destroy
    @exam = Exam.find(params[:id])
    if  @exam.destroy
      @exam.event.event_series.destroy if event
      render :template => 'exams/destroy_success'
    else
      render :template => 'exams/destroy_failure'
    end
  end  
  
end