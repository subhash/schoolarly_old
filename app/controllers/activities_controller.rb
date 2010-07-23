class ActivitiesController < ApplicationController
  
  def new
    @assessment = Assessment.find_by_id(params[:assessment_id])
    @assessment_tool = AssessmentTool.new(:assessment => @assessment, :weightage => @assessment.assessment_tools.size == 0 ? 100 : 0)
    @activity = Activity.new(:max_score =>@assessment.assessment_type.max_score)
    @event = Event.new( :start_time => Event.now, :end_time => Event.now.advance(:hours => 1 ))
    @assessment_tool_names = @assessment.school_subject.assessment_tool_names
    render :update do |page|
      page.open_dialog "New activity for #{@assessment.long_name}", :partial => 'activities/new', :locals => {:activity => @activity}
    end
  end
  
  def create
    notifiers = []
    @assessment_tool = AssessmentTool.new(params[:assessment_tool])
    assessment_tool_existing = @assessment_tool.assessment.assessment_tools.find_by_name(@assessment_tool.name)
    @activity  = Activity.new(params[:activity])
    @activity.assessment_tool = assessment_tool_existing ? assessment_tool_existing : @assessment_tool
    unless(params[:event][:start_time].blank? and params[:event][:end_time].blank?)
      @event = Event.new(params[:event])
      event_series = EventSeries.new(:title => "#{@assessment_tool.assessment.long_name} : #{@activity.name}", :description => @activity.description, :owner => current_user)
      event_series.users = @activity.assessment_tool.assessment.current_participants.collect(&:user)
      @event.event_series = event_series
      notifiers << event_series
      @activity.event  = @event
    end
    render :update do |page|
      if @activity.save
        page.close_dialog
        notify(notifiers)
        page.replace_object @activity.assessment, :partial => 'assessments/assessment'
      else
        @assessment = @assessment_tool.assessment
        @assessment_tool_names = @assessment.school_subject.assessment_tool_names
        page.refresh_dialog  :partial => 'activities/new', :locals => {:activity => @activity}
      end
    end
  end
  
  def edit
    @activity = Activity.find_by_id(params[:id])
    @event = @activity.event ? @activity.event : Event.new
    render :update do |page|
      page.open_dialog "Change activity - #{@activity.title}", :partial => 'activities/edit'
    end
  end
  
  def update
    notifiers = []
    @activity = Activity.find_by_id(params[:id])
    @activity.attributes = params[:activity]
    if @activity.event
      @activity.event.attributes = params[:event]
      notifiers << @activity.event if @activity.event.changed?
    else
      unless(params[:event][:start_time].blank? and params[:event][:end_time].blank?)
        @event = Event.new(params[:event])
        event_series = EventSeries.new(:title => @activity.title, :description => @activity.description, :owner => current_user)
        event_series.users = @activity.participants.collect(&:user)
        @event.event_series = event_series
        @activity.event = @event
        notifiers << event_series
      end
    end
    render :update do |page|
      if @activity.save
        notify(notifiers)
        page.close_dialog
        page.replace_object @activity, :partial => 'activities/activity'
      else
        @event = @activity.event ? @activity.event : Event.new
        page.refresh_dialog  :partial => 'activities/edit'
      end
    end
  end
  
  def destroy
    @activity = Activity.find(params[:id])
    render :update do |page|
      if  @activity.destroy
        @activity.event.event_series.destroy if @activity.event
        page.remove_object(@activity)
      else
        page.error_dialog('Error occurred while removing the activity.')
      end
    end
  end  
  
  def edit_scores
    session[:redirect] = request.request_uri
    @activities = Activity.find_all_by_id(params[:ids])
    @activity = @activities.first
  end
  
  def view_scores
    session[:redirect] = request.request_uri
    @activities = Activity.find_all_by_id(params[:ids])
    @activity = @activities.first
  end
  
end
