class AssessmentsController < ApplicationController
  
#  def destroy
#    @assessment = Assessment.find_by_id(params[:id])
#    render :update do |page|
#      if  @assessment.destroy
#        @assessment.activities.each do |activity|
#          activity.event.event_series.destroy if activity.event
#        end
#        page.remove_object(@assessment)
#      else
#        page.error_dialog('Error occurred while removing assessment.')
#      end
#    end
#  end
  
  def edit
    @assessment = Assessment.find_by_id(params[:id])
    @student = Student.find_by_id(params[:student_id]) if params[:student_id]
    render :update do |page|
      page.open_dialog "Calculations for "+@assessment.long_name, :partial => 'assessments/edit'
    end
  end
  
  def update
    @assessment = Assessment.find_by_id(params[:id])
    @assessment.update_attributes(params[:assessment])
    @student = Student.find_by_id(params[:student_id]) if params[:student_id]
    render :update do |page|
      if @assessment.save 
        page.close_dialog
        page.replace_object @assessment, :partial => 'assessments/assessment'
      else
        page.refresh_dialog :partial => 'assessments/edit'
      end
    end
  end
end
