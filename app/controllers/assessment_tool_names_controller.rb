class AssessmentToolNamesController < ApplicationController
  
  def new
    @school_subject = SchoolSubject.find(params[:school_subject_id])
    @assessment_tool_name = AssessmentToolName.new(:school => @school_subject.school)
    render :update do |page|
      page.open_dialog 'Add Assessment Tools for '+ @school_subject.school.name + ' - ' + @school_subject.name , :partial => 'assessment_tool_names/new', :locals => {:assessment_tool_names => @school_subject.school.assessment_tool_names, :assessment_tool_name => @assessment_tool_name, :school_subject => @school_subject}
    end
  end
  
  def create
    @assessment_tool_name = AssessmentToolName.new(params[:assessment_tool_name]) 
    @school_subject = SchoolSubject.find_by_id(params[:school_subject_id])
    @school_subject.assessment_tool_name_ids = params[:tool_name_ids]
    render :update do |page|     
      unless @assessment_tool_name.name.blank?
        if @assessment_tool_name.save 
          @school_subject.assessment_tool_names << @assessment_tool_name
          @school_subject.save
          page.close_dialog
          page.replace_object @school_subject, :partial => 'school_subjects/school_subject'
        else
          page.refresh_dialog :partial => 'assessment_tool_names/new', :locals => {:assessment_tool_names => @school_subject.school.assessment_tool_names, :assessment_tool_name => @assessment_tool_name, :school_subject => @school_subject}
        end
      else
        @school_subject.save
        page.close_dialog
        page.replace_object @school_subject, :partial => 'school_subjects/school_subject'
      end
    end
  end
  
end
