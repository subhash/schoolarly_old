class KlassesController < ApplicationController
  
  before_filter :find_school , :only => [:new, :create]
  
  def index
    @klasses=Klass.all :order => "school_id, level, division"
  end
  
  def create
    @klass = Klass.new(params[:klass])
    if (@school.klasses << @klass)
      respond_to do |format|
        format.js {render :template => 'klasses/create_success'}
      end 
    else
      respond_to do |format|          
        format.js {render :template => 'klasses/create_error'}
      end  
    end    
  end
  
  def destroy    
    @klass= Klass.find(params[:id])
    @klass_exams = @klass.school.klasses.each_with_object({}) do |klass, hash|
      hash[klass.id] = klass.exams.group_by{|e| e.exam_group}
    end
    if(current_user.person.is_a?(SchoolarlyAdmin))
      @klass.papers.destroy_all
      @klass.exam_groups.destroy_all
      @klass.destroy
      redirect_to :action => 'index'
    else
      @deleted_klass = @klass
      @klass.destroy
      respond_to do |format|
        format.js {render :template => 'klasses/delete'}
      end
    end
  end
  
  def show
    @klass = Klass.find(params[:id])
    @school = @klass.school
    add_breadcrumb(@school.name, @school)
    add_breadcrumb(@klass.name)    
#    @exam_groups = ExamGroup.find(:all, :conditions => {:klass_id => @klass.id})
    add_js_page_action(:title => 'Add Students', :render => {:partial =>'students/add_students_form',:locals => {:entity => @klass, :students => @school.students.not_enrolled, :selected => @klass.student_ids }})
    add_js_page_action(:title => 'Add Subjects', :render => {:partial => 'papers/create_papers_form', :locals => {:klass => @klass, :subjects => Subject.find(:all)}})
#    add_js_page_action(:title => 'Add Exams', :render => {:partial =>'exam_groups/new', :locals => {:exam_group => ExamGroup.new(), :subjects => @subjects, :klass => @klass, :exam_types => ExamType.all}})        
#    @teacher_subject_allotments= @klass.current_klass_allotments.collect{|klass_allotment| klass_allotment.teacher_subject_allotment}.group_by{|s| s.subject.id}
    @exam_groups = @klass.exam_groups
    session[:redirect] = request.request_uri
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @klass }
    end
  end  
  
  def find_school    
    if(params[:school_id])
      @school = School.find(params[:school_id])
    end
  end   
  
  def add_subjects
    @klass = Klass.find(params[:id])
    subject_ids = params[:klass][:subject_ids]
    subject_ids.each do |subject_id|
      @klass.papers << Paper.new(:subject_id => subject_id)
    end
    @klass.save!
  end
  
  def add_students
    @klass = Klass.find(params[:id])  
    new_ids = params[:klass][:student_ids]
    #    have to do this since multi-select always returns one empty selection - TODO explore why
    @new_students = Student.find(new_ids.to(-2))
    @new_students.each do |student|
      student.klass = @klass
      student.save!      
    end
    @klass.save!
    @addable_students = @klass.school.students.not_enrolled
  end
  
end
