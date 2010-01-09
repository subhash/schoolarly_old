class KlassesController < ApplicationController
  
  before_filter :find_school , :only => [:new, :create]
  
  def index
    @klasses=Klass.all :order => "school_id, level, division"
  end
  
  def new
    @klass = Klass.new
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
  
#  When a klass is deleted from the UI by the school
  def delete
    @klass = Klass.find(params[:id])
    @deleted_klass = @klass
    @klass.destroy
  end
  
  def destroy
    @klass= Klass.find(params[:id])
    @klass.destroy
    redirect_to :action => 'index'
  end
  
  def show
    @klass = Klass.find(params[:id])   
    @school = @klass.school
    add_breadcrumb(@school.name, @school)
    add_breadcrumb(@klass.name)
    add_js_page_action('Add Exam Group', :partial =>'exam_groups/new', :locals => {:exam_types => ExamType.find(:all)})
    @all_subjects = Subject.find(:all)
    add_js_page_action('Add/Remove Subjects',:partial => 'subjects/add_subjects_form', :locals => {:entity => @klass, :subjects => @all_subjects , :disabled => @klass.allotted_subjects})    
    @students = @klass.current_students      
    @subjects = @klass.subjects
    @teacher_allotments= @klass.teacher_allotments.current.group_by{|a| a.subject.id}
    @exams=@klass.exams.group_by{|e| e.exam_group}
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
    @klass.subject_ids = params[:klass][:subject_ids] + @klass.allotted_subjects
    @all_subjects = Subject.find(:all, :order => :name)
    @teacher_allotments = TeacherAllotment.current_for_klass(@klass.id).group_by{|a| a.subject.id}
  end
  
  def remove_student
    @student = Student.find(params[:id])
    @klass = @student.current_enrollment.klass
    @student.current_enrollment.end_date = Time.now.to_date
    @student.current_enrollment.admission_number = @student.admission_number
    @student.current_enrollment = nil
    @student.admission_number = nil
    @student.save!
  end
  
  def delete_allotment
    @klass = Klass.find(params[:id])
    @teacher_allotment = TeacherAllotment.find(params[:allotment_id])
    @teacher_allotment.is_current = false
    @all_subjects = Subject.find(:all)
  end
  
end
