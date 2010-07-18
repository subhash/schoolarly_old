class AssessmentsController < ApplicationController
  
  def destroy
    @assessment = Assessment.find_by_id(params[:id])
    render :update do |page|
      if  @assessment.destroy
        @assessment.activities.each do |activity|
          activity.event.event_series.destroy if activity.event
        end
        page.remove_object(@assessment)
      else
        page.error_dialog('Error occurred while removing assessment.')
      end
    end
  end
  
  def edit
    @assessment = Assessment.find_by_id(params[:id])
    render :update do |page|
      page.open_dialog "Calculations for "+@assessment.long_name, :partial => 'assessments/edit'
    end
  end
  
  def update
    
  end
end
