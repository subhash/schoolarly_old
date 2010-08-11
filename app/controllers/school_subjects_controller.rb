class SchoolSubjectsController < ApplicationController
  def new
    @school = School.find(params[:school_id])
    render :update do |page|
      page.open_dialog "Subjects taught in #{@school.name}",:partial => 'school_subjects/new', :locals => {:school => @school, :subjects => Subject.all} 
    end
  end
  def create
    @school = School.find_by_id(params[:school_id])
    @school.subject_ids = params[:subject_ids]
    render :update  do |page|
      if @school.save
        page.close_dialog
        page.replace_tab Subject, :partial => 'school_subjects/school_subjects', :object => @school.school_subjects
      else
        page.refresh_dialog :partial => 'school_subjects/new', :locals => {:school => @school, :subjects => Subject.all}
      end
    end
  end
  
end
