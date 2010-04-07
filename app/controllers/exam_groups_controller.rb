class ExamGroupsController < ApplicationController
  
  protect_from_forgery :only => [:create, :update, :destroy] 
 
  def self.in_place_loader_for(object, attribute, options = {})
    define_method("get_#{object}_#{attribute}") do
      @item = object.to_s.camelize.constantize.find(params[:id])
      render :text => (@item.send(attribute).blank? ? "[No Name]" : @item.send(attribute))
    end
  end  
  in_place_edit_for :exam_group, :description
  in_place_loader_for :exam_group, :description
  
  def create
    @exam_group=ExamGroup.new(params[:exam_group])
    @klass=@exam_group.klass
    @exam_group.description = @exam_group.exam_type.description + ' for ' + @klass.name
    @exam_group.subject_ids = params[:exam][:subject_ids]
    @exam_group.save!
    @exam_group.exams.each do |exam|
      exam.teacher=Paper.find_by_klass_id_and_subject_id(@klass.id, exam.subject_id).teacher
      exam.save!
    end
    options = params[:options].collect{|p| p.to_sym}
    respond_to do |format|
      format.js {render_success :object => @exam_group, :insert => {:partial => 'exam_groups/exam_group', :locals => {:options => options, :klass => @klass}}}
    end 
    rescue Exception => e
      @exam_group=ExamGroup.new(params[:exam_group])
      @klass=@exam_group.klass
      @exam_group.subject_ids = params[:exam][:subject_ids]
      respond_to do |format|          
        format.js {
          render_failure :refresh => {:partial => 'exam_groups/new', :locals => {:exam_group => @exam_group, :subjects => @klass.subjects, :klass => @klass, :exam_types => ExamType.all}}
        }
      end           
    end
 
  def destroy
    exam_group=ExamGroup.find(params[:id])
    @klass=exam_group.klass
    exam_group.destroy
    render :update do |page|
      page.remove_object(exam_group)
    end
  end
  
end
