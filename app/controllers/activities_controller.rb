class ActivitiesController < ApplicationController
  
  def new
    @assessment = Assessment.find_by_id(params[:assessment_id])
    @assessment_tool = AssessmentTool.new(:assessment => @assessment)
    @activity = Activity.new(:max_score =>@assessment.assessment_type.max_score)
    @event = Event.new( :start_time => Event.now, :end_time => Event.now.advance(:hours => 1 ))
    @assessment_tool_names = @assessment.school_subject.assessment_tool_names
    render :update do |page|
      page.open_dialog "New activity for #{@assessment.long_name}", :partial => 'activities/new', :locals => {:activity => @activity}
    end
  end
  
  def create
    @assessment_tool = AssessmentTool.new(params[:assessment_tool])
    assessment_tool_existing = @assessment_tool.assessment.assessment_tools.find_by_name(@assessment_tool.name)
    @activity  = Activity.new(params[:activity])
    @activity.assessment_tool = assessment_tool_existing ? assessment_tool_existing : @assessment_tool
    unless(params[:event][:start_time].blank? and params[:event][:end_time].blank?)
      @event = Event.new(params[:event])
      event_series = EventSeries.new(:title => "#{@assessment_tool.assessment.long_name} : #{@activity.name}", :description => @activity.description, :owner => current_user)
      event_series.users = @activity.assessment_tool.assessment.participants.collect(&:user)
      @event.event_series = event_series
      event_series.events << @event
      @activity.event  = @event
    end
    render :update do |page|
      if @activity.save 
        page.close_dialog
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
    @activity.event = Event.new unless @activity.event
    render :update do |page|
      page.open_dialog "Change activity - #{@activity.title}", :partial => 'activities/edit'
    end
  end
  
  def update
    @activity = Activity.find_by_id(params[:id])
    @activity.update_attributes(params[:activity])
    @activity.event = nil if @activity.event.invalid?
    if @activity.event and @activity.event.new_record?
      @event_series = EventSeries.new(:title => @activity.title, :description => @activity.description, :owner => current_user)
      @activity.participants.each do |participant|
        @event_series.users << participant.user
      end
      @activity.event.event_series = @event_series
    end
    render :update do |page|
      if @activity.save
        page.close_dialog
        page.replace_object @activity, :partial => 'activities/activity'
      else
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
  
end
