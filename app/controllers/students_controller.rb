class StudentsController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  
  protect_from_forgery :only => [:create, :update, :destroy] 
  
  # GET /students/1
  # GET /students/1.xml
  def show
    session[:redirect] = request.request_uri
    @student = Student.find(params[:id])
    @school = @student.school
    @current_enrollment = @student.current_enrollment
    if @school
      add_breadcrumb(@school.name, @school)    
      if @current_enrollment
        @student_enrollment = @current_enrollment
        @klass = @current_enrollment.klass
        @teacher_allotments= @klass.teacher_allotments.current.group_by{|a| a.subject.id}
        @all_subjects = Subject.find(:all, :order => 'name')
        add_breadcrumb(@klass.name,@klass)
        add_js_page_action('Add/Remove Subjects',:partial => 'subjects/add_subjects_form', :locals => {:entity => @student_enrollment, :subjects => @klass.subjects,:disabled => [] })
      else
        @year = Klass.current_academic_year(@school)
        @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
        @student_enrollment = StudentEnrollment.new
        @student_enrollment.student = @student
        @student_enrollment.admission_number = @student.admission_number
        add_page_action('Assign Class',  {:controller => 'student_enrollment', :action => 'new', :id => @student})
      end
    else
      add_js_page_action('Add to school', :partial =>'students/add_to_school_form', :locals => {:student => @student, :schools => School.find(:all)})
    end
    add_breadcrumb(@student.name)
  end
  # GET /students/new
  # GET /students/new.xml
  def new
    @student = Student.new
    @user = User.new
  end 
  
  # POST /students
  # POST /students.xml
  def create
    @student = Student.new(params[:student])
    @user = User.new(params[:user])
    @student.user = @user
    if(params[:school_id])
      @school = School.find(params[:school_id])
      @student.school = @school
    end
    begin
      Student.transaction do
        @student.save!
        @user.invite!
        respond_to do |format|
          flash[:notice] = 'Student was successfully created.'
          format.js {render :template => 'students/create_success'}
          format.html { redirect_to(edit_password_reset_url(@user.perishable_token)) }
        end     
      end      
    rescue Exception => e
      puts e.inspect
      # handle error
      @student = Student.new(params[:student])
      @student.user = @user      
      respond_to do |format|          
        format.js {render :template => 'students/create_error'}
        format.html { render :action => "new" }
      end           
    end
  end
 
  def add_subjects
    @student_enrollment = StudentEnrollment.find(params[:id])
    @klass = @student_enrollment.klass
    @student_enrollment.subject_ids = params[:student_enrollment][:subject_ids] + @klass.allotted_subjects
    @all_subjects = Subject.find(:all, :order => :name)
    @teacher_allotments = TeacherAllotment.current_for_klass(@klass.id).group_by{|a| a.subject.id}
  end
  
  def add_to_school
    @student = Student.find(params[:id])
    @school = School.find(params[:student][:school_id])
    @school.students << @student
    render :update do |page|
      page.redirect_to student_path(@student)
    end
  end
  
end
