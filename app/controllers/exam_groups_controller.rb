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
    ExamGroup.transaction do
      @exam_group.save!
      @exam_group.exams.each do |exam|
        exam.teacher=Paper.find_by_klass_id_and_subject_id(@klass.id, exam.subject_id).teacher
        exam.save!
      end
    end
    render :template => 'exam_groups/create_success'
  rescue Exception => e
    render :template => 'exam_groups/create_failure'
  end
 
  def destroy
    @exam_group=ExamGroup.find(params[:id])
    @exam_group.destroy
  end
  
end
