class AssessmentToolTypesController < ApplicationController
  
  def new
    @school_subject = SchoolSubject.find(params[:school_subject_id])
    @assessment_tool_type = AssessmentToolType.new(:school_subject => @school_subject)
    render :update do |page|
      page.open_dialog 'Add Assessment Tools for '+ @school_subject.school.name + ' - ' + @school_subject.name , :partial => 'assessment_tool_types/new', :locals => {:assessment_types => AssessmentType.all, :assessment_tool_type => @assessment_tool_type}
    end
  end
  
  def create
    @assessment_tool_name = AssessmentToolName.new(params[:assessment_tool_name]) 
    @assessment_tool_name.school_subject.assessment_tool_name_ids = params[:tool_ids]
    @assessment_tool_name.school_subject.save
    @assessment_tool_name.save unless @assessment_tool_name.name.blank?
    render :update do |page|      
        page.close_dialog
        page.replace_object @assessment_tool_name.school_subject, :partial => 'school_subjects/school_subject'
    end
  end
  
end
