class ActivitiesController < ApplicationController
  
  def new
    @assessment = Assessment.find_by_id(params[:assessment_id])
    @assessment_tool = AssessmentTool.new(:assessment => @assessment, :weightage => @assessment.assessment_tools.size == 0 ? 100 : 0)
    @activity = Activity.new(:max_score =>@assessment.assessment_type.max_score)
    @activity.event = Event.new
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
    if(@activity.event.start_time.blank? and @activity.event.end_time.blank? )
      @activity.event = nil
    else
      event_series = EventSeries.new(:title => "#{@assessment_tool.assessment.long_name} : #{@activity.name}", :description => @activity.description, :owner => current_user)
      event_series.users = @activity.assessment_tool.assessment.current_participants.collect(&:user)
      @activity.event.event_series = event_series
    end
    render :update do |page|
      if @activity.save
        @assessment = @activity.assessment
        page.replace_object @activity.assessment, :partial => 'assessments/assessment'
        page.open_dialog "Adjust calculations for "+@assessment.long_name, :partial => 'assessments/edit'
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
    @activity.attributes = params[:activity]
    if @activity.event.new_record?
      if (@activity.event.start_time.blank? and @activity.event.end_time.blank?)
        @activity.event = nil
      else
        event_series = EventSeries.new(:title => @activity.title, :description => @activity.description, :owner => current_user)
        event_series.users = @activity.participants.collect(&:user)
        @activity.event.event_series = event_series
      end
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
    @assessment = @activity.assessment
    render :update do |page|
      if  @activity.destroy
        page.remove_object(@activity)
        page.open_dialog "Adjust calculations for "+@assessment.long_name, :partial => 'assessments/edit' unless @assessment.assessment_tools.empty?
      else
        page.error_dialog('Error occurred while removing the activity.')
      end
    end
  end  
  
  def edit_scores
    session[:redirect] = request.request_uri
    @activities = Activity.find_all_by_id(params[:ids],:include => [:assessment_tool],  :order => "assessment_tools.name")
    @activity = @activities.first
  end
  
  def view_scores
    session[:redirect] = request.request_uri
    @activities = Activity.find_all_by_id(params[:ids],:include => [:assessment_tool],  :order => "assessment_tools.name")
    @activity = @activities.first
  end
  
end
