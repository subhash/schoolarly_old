class ExamsController < ApplicationController
  
  protect_from_forgery :only => [:create, :update, :destroy]
  
  #in_place_edit_with_validation_for :exam_group, :description
  in_place_edit_for :exam_group, :description

#  in_place_timepickr_for :exam, :start_time

  def self.in_place_loader_for(object, attribute, options = {})
    define_method("get_#{object}_#{attribute}") do
      @item = object.to_s.camelize.constantize.find(params[:id])
      render :text => (@item.send(attribute).blank? ? "[No Name]" : @item.send(attribute))
    end
  end  

  in_place_loader_for :exam_group, :description

  def exam_edit
    @exam_group=ExamGroup.find(params[:id])
    #subjects=@examgroup.klass.subjects
    subjects=Subject.find(:all)
    @subjects = subjects.map do |subject|
      [subject.name,subject.id]
    end
    render :update do |page|
      page.replace_html("exams_index_div", :partial => "exam_list", :object=> @exam_group) 
    end
  end
  
  def exam_update
    @exam_group=ExamGroup.find(params[:id])
    if params[:exam]
      Exam.update(params[:exam].keys, params[:exam].values)
    end
    if params[:cb]
      exams_marked_for_deletion=Exam.find(params[:cb].keys)
      Exam.destroy(exams_marked_for_deletion)
    end
    school=@exam_group.klass.school
    flash[:notice] = 'Exam Details were successfully updated.'
    redirect_to(:controller => :schools, :action => 'exam_groups_index', :id=>school, :exam_group => @exam_group)
  end
  
  def add_exam_dialog_show
    @exam_group=ExamGroup.find(params[:id])
    @subjects=Subject.find(:all)
    render :update do |page|
      page.call 'jQuery.noConflict'
      page.replace_html("add_exam", :partial =>'exams/new_exam', :object => @exam_group)
      page << "jQuery('#dialog_add_exam').dialog('open');"
    end
  end
  
  def add_exam
    @subjects=Subject.find(:all)
    exam_group=ExamGroup.find(params[:id])
    exam=Exam.new()
    exam.subject=Subject.find(params[:subject])
    exam.start_time=params[:start_time]
    exam.end_time=params[:end_time]
    exam.venue=params[:venue]
    exam.max_score=params[:max_score]
    exam.pass_score=params[:pass_score]
    exam_group.exams << exam
    exam_group.save!
    exams=exam_group.exams
    if exam_group.exams.count==1
      render :update do |page|
        page << "jQuery('#dialog_add_exam').dialog('close');"
        page.replace_html("exams_index_div", :partial =>'exams', :object => exam_group)
      end
    else
      render :update do |page|
        page << "jQuery('#dialog_add_exam').dialog('close')"
        page.insert_html(:bottom, "exam_list_table", :partial =>'exam', :object => exam)
      end
    end    
  rescue Exception => e
    flash[:notice]="Error occured in exam add: <br /> #{e.message}"
  end
  
  def delete
    @exam = Exam.find(params[:id])
    @exam.destroy
  end
end