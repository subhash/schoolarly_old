class StudentsController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  
  protect_from_forgery :only => [:create, :update, :destroy]
  
  def index
    @students = Student.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end
  
  
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
      add_js_page_action('Add to school', :partial =>'schools/add_to_school_form', :locals => {:exam_types => ExamType.find(:all)})
    end
    add_breadcrumb(@student.name)
  end
  # GET /students/new
  # GET /students/new.xml
  def new
    @student = Student.new
    @user = User.new
  end
  
  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
  end
  
  
  # POST /students
  # POST /students.xml
  def create
    @student = Student.new(params[:student])
    @school = School.find(params[:school_id])
    @user = User.new(params[:user])
    @student.user = @user
    @student.school = @school
    begin
      Student.transaction do
        @student.save!
        @user.invite!
        respond_to do |format|
          flash[:notice] = 'Student was successfully created.'
          format.js {render :template => 'students/create_success'}
        end     
      end      
    rescue Exception => e
      puts e.inspect
      # handle error
      @student = Student.new(params[:student])
      @student.user = @user      
      respond_to do |format|          
        format.js {render :template => 'students/create_error'}
      end           
    end
  end
  
  
  # PUT /students/1
  # PUT /students/1.xml
  def update
    @student = Student.find(params[:id])
    
    respond_to do |format|
      if @student.update_attributes(params[:student])
        flash[:notice] = 'Student was successfully updated.'
        format.html { redirect_to(@student) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /students/1
  # DELETE /students/1.xml
  def destroy
    @student = Student.find(params[:id])
    @student.user.destroy
    @student.destroy
    
    respond_to do |format|
      format.html { redirect_to(students_url) }
      format.xml  { head :ok }
    end
  end
  
  def self.tabs(student_id)
    user_id=Student.find(student_id).user.id
    tabs = [:Home => {:controller => :students, :action => 'show', :id=>student_id},
    :Subjects => '#',
    :Messages => '#',
    :Calendar => '#',    
    :Leave => '#',
    :Exams => '#',
    :Scores => '#',
    :AcademicHistory => '#',
    "Class/Subjects" => '#',
    :Profile =>  {:controller => :user_profiles, :action => 'show', :id=>user_id} ]
    return tabs
  end
  
  def add_subjects
    @student_enrollment = StudentEnrollment.find(params[:id])
    @klass = @student_enrollment.klass
    @student_enrollment.subject_ids = params[:student_enrollment][:subject_ids] + @klass.allotted_subjects
    @all_subjects = Subject.find(:all, :order => :name)
    @teacher_allotments = TeacherAllotment.current_for_klass(@klass.id).group_by{|a| a.subject.id}
  end
  
end
