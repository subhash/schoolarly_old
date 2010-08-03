class AssessmentGroupsController < ApplicationController
  
  def edit
    @klass = Klass.find(params[:klass_id])
    render :update do |page|
      page.open_dialog "Settings for assessments for #{@klass.name}", :partial => 'assessment_groups/edit'
    end
  end
  
  def update
    @klass = Klass.find(params[:klass_id])
    @klass.attributes = params[:klass]
    render :update do |page|
      if @klass.save
        page.close_dialog
      else
        page.refresh_dialog :partial => 'assessment_groups/edit'
      end
    end
  end
  
end
