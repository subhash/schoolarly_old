class ActivitiesController < ApplicationController
  
  def new
    @assessment = Assessment.find_by_id(params[:assessment_id])
    assessment_tool = AssessmentTool.new(:assessment => @assessment)
    @activity = Activity.new(:max_score =>@assessment.assessment_type.max_score)
    @activity.event = Event.new( :start_time => Event.now, :end_time => Event.now.advance(:hours => 1 ))
    assessment_tool_names = @assessment.school_subject.assessment_tool_names
    render :update do |page|
      page.open_dialog "New activity for #{@assessment.long_name}", :partial => 'activities/new', :locals => {:activity => @activity, :assessment_tool => assessment_tool, :assessment_tool_names => assessment_tool_names}
    end
  end
  
  def create
    @assessment_tool = AssessmentTool.new(params[:assessment_tool])
    assessment_tool_existing = @assessment_tool.assessment.assessment_tools.find_by_name(@assessment_tool.name)
    @activity  = Activity.new(params[:activity])
    @activity.assessment_tool = assessment_tool_existing ? assessment_tool_existing : @assessment_tool
    @activity.save!
    @event_series = EventSeries.new(:title => @activity.title, :description => @activity.description, :owner => current_user)
      @activity.participants.each do |participant|
        @event_series.users << participant.user
      end
      @activity.event.event_series = @event_series
    render :update do |page|
      if @activity.save
        page.close_dialog
        page.replace_object @activity.assessment, :partial => 'assessments/assessment'
      else
        page.refresh_dialog  :partial => 'activities/new', :locals => {:activity => @activity, :assessment_tool => @assessment_tool, :assessment_tool_names => @assessment.school_subject.assessment_tool_names}
      end
    end
  end
end
