class KlassesController < ApplicationController
  
  before_filter :find_school , :only => [:new, :create]
  
  def index
    @klasses=Klass.all :order => "school_id, level, division"
  end
  
  def create
    @klass = Klass.new(params[:klass])
    if (@school.klasses << @klass)
      render :template => 'klasses/create_success'
    else
      render :template => 'klasses/create_error'  
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
    end
  end
  
  def show
    @klass = Klass.find(params[:id])
    @school = @klass.school
    add_breadcrumb(@school.name, @school)
    add_breadcrumb(@klass.name)
    @subjects=@klass.subjects
    add_js_page_action(:title => 'Add Students', :render => {:partial =>'students/add_students_form',:locals => {:entity => @klass, :students => @school.students.not_enrolled}})
    add_js_page_action(:title => 'Add Subjects', :render => {:partial => 'papers/create_papers_form', :locals => {:klass => @klass, :subjects => Subject.find(:all)}})
    add_js_page_action(:title => 'Add Exams', :render => {:partial =>'exam_groups/new_exam_group_form', :locals => {:exam_group => ExamGroup.new(), :subjects => @subjects, :klass => @klass, :exam_types => ExamType.all}})        
    @exam_groups = @klass.exam_groups.group_by{|eg| eg.klass}
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
  end
  
  def remove_student
    @student = Student.find(params[:id])
    @klass = @student.klass
    @student.papers.delete_all
    @student.klass = nil
    @student.save!
  end
  
end
