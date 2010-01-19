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
        add_js_page_action(:title => 'Add/Remove Subjects',:render => {:partial => 'subjects/add_subjects_form', :locals => {:entity => @student_enrollment, :subjects => @klass.subjects,:disabled => [] }})
      else
        @year = Klass.current_academic_year(@school)
        @klasses = @school.klasses.in_year(@year)
        @student_enrollment = StudentEnrollment.new
        @student_enrollment.student = @student
        @student_enrollment.admission_number = @student.admission_number
        add_js_page_action(:title => 'Assign Class', :id => "new-enrollment-for-#{@student.id}", :render => {:partial => 'student_enrollments/new_enrollment_form', :locals => {:student_enrollment => @student_enrollment, :klasses => @klasses}})
      end
    else
      add_js_page_action(:title => 'Add to school', :render => {:partial =>'students/add_to_school_form', :locals => {:student => @student, :schools => School.find(:all)}})
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
    #    TODO - if the user already exists, with school not assigned, 
    #we should let that be added to school after enough warnings
    
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
          format.html { redirect_to(edit_password_reset_url(@user.perishable_token)) }
          format.js {render :template => 'students/create_success'}
        end     
      end      
    rescue Exception => e
      puts e.inspect
      # handle error
      @student = Student.new(params[:student])
      @student.user = @user      
      respond_to do |format|          
        format.html { render :action => "new" }
        format.js {render :template => 'students/create_error'}
      end           
    end
  end
  
  def add_subjects
    @student_enrollment = StudentEnrollment.find(params[:id])
    @klass = @student_enrollment.klass
    @student_enrollment.subject_ids = params[:student_enrollment][:subject_ids]
    @all_subjects = Subject.find(:all, :order => :name)
    @teacher_allotments = TeacherAllotment.current_for_klass(@klass.id).group_by{|a| a.subject.id}
  end
  
  def add_to_school
    @student = Student.find(params[:id])
    @school = School.find(params[:student][:school_id])
    @school.students << @student
    @school.save!
    render :update do |page|
      page.redirect_to student_path(@student)
    end
  end
  
end
