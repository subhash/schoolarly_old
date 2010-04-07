class ExamsController < ApplicationController
  
  protect_from_forgery :only => [:create, :update, :destroy]

  def to_symb(entity)
    return entity.class.name.underscore.downcase.intern
  end
  
  def get_entity(entity_class,entity_id)
    Object.const_get(entity_class).find(entity_id)
  end

  def show
    @exam=Exam.find(params[:id])
    add_breadcrumb(@exam.klass.school.name, @exam.klass.school)
    add_breadcrumb(@exam.klass.name, @exam.klass)
    add_breadcrumb(@exam.to_s)
    @exam_groups = [@exam.exam_group].group_by{|eg| eg.klass}
  end
  
  def new
    @exam_group = ExamGroup.find(params[:exam_group])
    @exam = Exam.new(:exam_group => @exam_group)
    entity_class = params[:entity_class]
    entity = get_entity(entity_class,params[:entity_id])
    if entity_class == 'Teacher' || entity_class == 'School'
      @new_subjects = entity.subjects_for_klass(@exam_group.klass.id) - @exam_group.subjects
    else
      @new_subjects = entity.subjects - @exam_group.subjects      
    end
    #args = @new_subjects.empty? ? {:text =>'<blockquote>' + get_message_text(:message_if_empty_unallotted_papers) + '</blockquote>'} : {:partial => 'exams/new', :locals => {:exam => @exam, :subjects => @new_subjects, :entity => entity}}
    args = {:partial => 'exams/new', :locals => {:exam => @exam, :subjects => @new_subjects, :entity => entity}} 
    render :update do |page|
      page.open_dialog('Add Exam', args)
    end
  end
  
  def create
    @exam = Exam.new(params[:exam])
    exam_group=ExamGroup.find(params[:exam_group_id])
    @exam.exam_group=exam_group
    @exam.teacher=Paper.find_by_klass_id_and_subject_id(exam_group.klass.id, @exam.subject_id).teacher
    @exam.save!
    entity = get_entity(params[:entity_class],params[:entity_id])
    options = params[:options].collect{|p| p.to_sym}
    respond_to do |format|
      format.js {render_success :object => exam_group, :replace => {:partial => 'exam_groups/exam_group', :locals => {:options => options, to_symb(entity) => entity}}}
    end 
  rescue Exception => e
    @exam = Exam.new(params[:exam])
    entity = get_entity(params[:entity_class],params[:entity_id])
    respond_to do |format|
      render_failure :refresh => {:partial => 'exams/new', :locals => {:exam => @exam, :subjects => Subject.find(params[:subjects]), :entity => entity}}
    end 
  end
  
  def edit
    @exam = Exam.find(params[:id])
    entity = get_entity(params[:entity_class],params[:entity_id])
    render :update do |page|
      page.open_dialog('Modify Exam', {:partial =>'exams/edit', :locals => {:exam => @exam, :entity => entity}})
    end
  end
  
  def update
    @exam=Exam.find(params[:id])
    entity = get_entity(params[:entity_class],params[:entity_id])
    options = params[:options].collect{|p| p.to_sym} 
    if params
      @exam.update_attributes!(params[:exam])
    end
    respond_to do |format|
      format.js {render_success :object => @exam, :replace => {:partial => 'exams/exam', :locals => {:options => options, to_symb(entity) => entity}}}
    end 
  rescue Exception => e
    @exam=Exam.find(params[:id])
    entity = get_entity(params[:entity_class],params[:entity_id])
    respond_to do |format|
      render_failure :refresh => {:partial => 'exams/edit', :locals => {:exam => @exam, :entity => entity}}
    end
  end
  
  def destroy
    exam = Exam.find(params[:id])
    exam.destroy
    render :update do |page|
      page.remove_object(exam)
    end
  end  
  
end