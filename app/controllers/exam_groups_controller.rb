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
    respond_to do |format|
      flash[:notice] = 'Exams were successfully created.'
      format.js {render :template => 'exam_groups/create_success'}
    end 
  rescue Exception => e
    respond_to do |format|
      format.js {render :template => 'exam_groups/create_error'}
    end 
  end 
 
  def destroy
    @active_tab = :Exams
    exam_group=ExamGroup.find(params[:id])
    @klass=exam_group.klass
    exam_group.destroy
    respond_to do |format|
      flash[:notice] = 'Exam group was successfully removed.'
      format.js {render :template => 'exam_groups/destroy'}
    end 
  end
  
end
