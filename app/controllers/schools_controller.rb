class SchoolsController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  #permit "creator of Student", :except => :index
  protect_from_forgery :only => [:create, :update, :destroy]
  
  # GET /schools
  # GET /schools.xml
  def index
    @schools = School.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
  end
  
  # GET /schools/1
  # GET /schools/1.xml
  def show    
    @school=School.find(params[:id])
    add_breadcrumb(@school.name)
    add_page_action('Edit Profile', {:controller => :user_profiles, :action => 'edit', :id => @school.user})    
    add_js_page_action('Add class',:partial => 'klasses/new_klass_form', :locals => {:klass => Klass.new, :school => @school})
    add_js_page_action('Invite Student',:partial => 'students/invite_student_form', :locals => {:student => Student.new, :school => @school})
    add_js_page_action('Invite Teacher',:partial => 'teachers/invite_teacher_form', :locals => {:teacher => Teacher.new, :school => @school})
    @klasses = @school.klasses.in_year(Klass.current_academic_year(@school)).group_by{|klass|klass.level}
    @exam_groups = @school.exam_groups.group_by{|eg| Klass.find(eg.klass_id)}
    @students = @school.students
    @teachers = @school.teachers
    @subjects=@school.current_teacher_allotments.group_by{|a| a.teacher_id}
    session[:redirect] = request.request_uri
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school }
    end
    
  end
  
  # GET /schools/new
  # GET /schools/new.xml
  def new
    @school = School.new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school }
    end
  end
  
  # GET /schools/1/edit
  def edit
    @school = School.find(params[:id])
    @user = @school.user
    @user_profile=@user.user_profile
  end
  
  # POST /schools
  # POST /schools.xml
  def create
    @school = School.new(params[:school])
    @user = User.new(params[:user])
    @user.person = @school
    respond_to do |format|
      if @user.invite!
        flash[:notice] = 'School was successfully created.'
        format.html { redirect_to(edit_password_reset_url(@user.perishable_token)) }
        format.xml  { render :xml => @school, :status => :created, :location => @school }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /schools/1
  # PUT /schools/1.xml
  def update
    #@active_tab = :Profile
    @school = School.find(params[:id])
    
    respond_to do |format|
      if @school.update_attributes(params[:school]) 
        flash[:notice] = 'School was successfully updated.'
        format.html { redirect_to(@school) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /schools/1
  # DELETE /schools/1.xml
  def destroy
    @school = School.find(params[:id])
    @school.user.destroy
    @school.destroy
    
    respond_to do |format|
      format.html { redirect_to(schools_url) }
      format.xml  { head :ok }
    end
  end
  
  def teachers_index
    @active_tab = :Teachers
    @school=School.find(params[:id])
    set_active_user(@school.user.id)
    @teachers=@school.teachers
    if @teachers.empty?
      flash[:notice] = 'No teacher exists.'
    end
    @year = Klass.current_academic_year(@school)
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
  end
  
  def new_teacher
    @active_tab = :Teachers
    @user = User.new
    @school = School.find(params[:id])
    render :update do |page|      
      page.replace_html("new_teacher_form", :partial => "schools/new_teacher")
      page[:new_teacher_form].show
    end        
  end
  
  def create_teacher
    @school = School.find(params[:school_id])
    @user = User.new(params[:user])
    if(@user.save)
      @teacher = Teacher.new
      @teacher.user = @user
      @user.person = @teacher
      @teacher.school = @school
      if @teacher.save
        @teachers = @school.teachers
        flash[:notice] = "Account registered!"        
        render :update do |page|
          page.select("form").first.reset
          page[:new_teacher_form].hide
          page.insert_html :bottom, 'teachers', :partial => "teacher_user", :object => @user
        end
      else
        render :action => :new
      end
    else
      render :action => :new
    end  
  end
  
  def add_teacher    
    @school = School.find(params[:school_id])
    if(params[:email])
      @user = User.find_by_email_and_person_type(params[:email], 'Teacher')
      if @user.nil?
        render :update do |page|
          page[:password].show
          page[:add_teacher_button].disable
        end
      else
        @teacher = @user.person
        @teacher.school = @school
        if @teacher.save
          @teachers = @school.teachers
          flash[:notice] = "Account registered!"
          render :update do |page|
            page.select("form").first.reset
            page[:new_teacher_form].hide
            page.insert_html :bottom, 'teachers', :partial => "teacher_user", :object => @user
          end
        end
      end
    end
  end 
  
  def auto_complete_for_teacher_email
    auto_complete_for_user_email(params[:user][:email],'Teacher')
  end
  
  def remove_student
    @student = Student.find(params[:id])
    @school = @student.school
    if(@student.current_enrollment)
      @student.current_enrollment.end_date = Time.now.to_date
      @student.current_enrollment.admission_number = @student.admission_number
      @student.current_enrollment = nil
    end
    @student.admission_number = nil
    @student.save!
    @school.students.delete(@student)
    @school.save!
    respond_to do |format|
      format.js {render :template => 'students/remove'}
    end 
  end
  
end
