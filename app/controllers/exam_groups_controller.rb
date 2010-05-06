require 'activesupport'

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
    if  @exam_group.save!
      @exam_group.exams.each do |exam|
        exam.participants.each do |participant|
          exam.event.users << participant.user
        end
      end
      render :template => 'exam_groups/create_success'
    else
      render :template => 'exam_groups/create_failure'
    end
  end
  
  def add_events
    @exam_group=ExamGroup.new(params[:exam_group])
    @klass=@exam_group.klass
    @exam_group.description = @exam_group.to_s
    params[:exam_group][:subject_ids].each do |id| 
      if !id.blank?
        paper = @klass.papers.find_by_subject_id(id)
        teacher =  paper ? paper.teacher : nil
        exam = Exam.new(:subject_id => id, :teacher => teacher) 
        rounding_for_minutes = (Time.now.min % 5).minutes
        event = Event.new(:start_time => Time.now - rounding_for_minutes, :end_time => 1.hour.from_now - rounding_for_minutes, :period => "Does not repeat", :title => (@exam_group.description+" : "+exam.subject.name), :description => (@exam_group.description+" : "+exam.subject.name), :owner => current_user)
        exam.event = event  
        @exam_group.exams << exam
      end
    end    
    if  @exam_group.valid?
      render :template => 'exam_groups/add_events'
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
