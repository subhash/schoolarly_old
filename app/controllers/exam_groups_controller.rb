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
  
  def christen(exam_group)
    exam_group.exam_type.description + ' for ' + exam_group.klass.name
  end
  
  def create
    @exam_group=ExamGroup.new(params[:exam_group])
    @klass=@exam_group.klass
    @exam_group.description = christen(@exam_group)
    @exam_group.subject_ids = params[:exam][:subject_ids]    
    if  @exam_group.save!
      render :template => 'exam_groups/create_success'
    else
      render :template => 'exam_groups/create_failure'
    end
  end
  
  def destroy
    @exam_group=ExamGroup.find(params[:id])
    if  @exam_group.destroy
      render :template => 'exam_groups/destroy_success'
    else
      render :template => 'exam_groups/destroy_failure'
    end
  end
  
end
