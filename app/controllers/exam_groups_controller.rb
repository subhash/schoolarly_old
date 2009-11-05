class ExamGroupsController < ApplicationController
  
  def remove_exam_group
    @active_tab = :Exams
    @exam_group=ExamGroup.find(params[:id])
    klass=@exam_group.klass
    div_name=klass.id.to_s + '_content_table'
    Exam.delete(@exam_group.exams)
    @exam_group.save!
    @exam_group.destroy
    if klass.exam_groups.empty?
      render :update do |page|      
        page.replace_html(div_name, :text => "<blockquote>No exam group added yet</blockquote>")
        page.replace_html("exams", :text => "")
      end
    else
      render :update do |page|      
        page.replace_html(div_name, :partial => 'exam_group', :collection => klass.exam_groups)
        page.replace_html("exams", :text => "")
      end
    end
    
  end
  
  def add_exam_group_dialog_show
    @klass=Klass.find(params[:id])
    @exam_types=ExamType.find(:all)
    render :update do |page|
      page.call 'jQuery.noConflict'
      page.replace_html("add_exam_group", :partial =>'exam_groups/new' , :object=>@klass)
      page << "jQuery('#dialog_add_exam_group').dialog({
            bgiframe: true,
            height: 198,
            width: 360,
            modal: true,
            autoOpen: false
        });"
      page << "jQuery('#dialog_add_exam_group').dialog('open');"   
    end
  end
  
  def add_exam_group
    @klass=Klass.find(params[:id])
    exam_group=ExamGroup.new()
    exam_group.exam_type=ExamType.find(params[:exam_type])
    exam_group.description=params[:description]
    @klass.exam_groups << exam_group
    @klass.save!
    div_name=@klass.id.to_s + '_content_table'
    if @klass.exam_groups.count==1
      render :update do |page|
        page << "jQuery('#dialog_add_exam_group').dialog('close');"
        page.replace_html(div_name, :partial =>'exam_group', :object => exam_group)
      end
    else
      render :update do |page|
        page << "jQuery('#dialog_add_exam_group').dialog('close');"
        page.insert_html(:bottom, div_name, :partial =>'exam_group', :object => exam_group)
      end
    end    
  rescue Exception => e
    flash[:notice]="Error occured in exam group add: <br /> #{e.message}"
    render :update do |page|
      page << "jQuery('#dialog_add_exam_group').dialog('close');"
      page.replace_html("exams", :text => flash[:notice])
    end
  end
  
   def show
    @active_tab = :Exams
    @exam_group=ExamGroup.find(params[:id])
    #@exams=@exam_group.exams
    #@subjects=@examgroup.klass.subjects
    @subjects=Subject.find(:all)
    render :partial => "show", :object=> @exam_group   
  end
  
end
