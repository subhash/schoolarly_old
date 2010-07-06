class AssessmentToolTypesController < ApplicationController
  
  def new
    @school_subject = SchoolSubject.find(params[:school_subject_id])
    @assessment_tool_type = AssessmentToolType.new(:school_subject => @school_subject)
    render :update do |page|
      page.open_dialog 'Add Assessment Tools for '+ @school_subject.school.name + ' - ' + @school_subject.name , :partial => 'assessment_tool_types/new', :locals => {:assessment_types => AssessmentType.all}
    end
  end
  
  def create
    @assessment_tool_type = AssessmentToolType.new(params[:assessment_tool_type])
    render :update do |page|
      if @assessment_tool_type.save
        page.close_dialog
        page.replace_object @assessment_tool_type.school_subject, :partial => 'school_subjects/school_subject'
      else
        page.refresh_dialog :partial => 'assessment_tool_types/new', :locals => {:assessment_types => AssessmentType.all}
      end
    end
  end
  
end
