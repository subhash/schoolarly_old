class AssessmentsController < ApplicationController
  
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
  
  def score_calculation
    @assessment = Assessment.find_by_id(params[:id])
    @student = Student.find_by_id(params[:student_id])
    render :update do |page|
      page.open_dialog "Score calculation for #{@assessment.long_name} - #{@student.name}", :partial => 'scores/calculation'
    end
  end
  
  def scores
    session[:redirect] = request.request_uri
    @assessment = Assessment.find(params[:id])
    @edit = (params[:edit] and params[:edit] == "true") ? true : false
  end
  
end
