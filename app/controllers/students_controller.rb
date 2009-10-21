class StudentsController < ApplicationController
  # GET /students
  # GET /students.xml
  
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
    @active_tab = :Home
    @student = Student.find(params[:id])
    set_active_user(@student.user)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end
  
  # GET /students/new
  # GET /students/new.xml
  def new
    @active_tab = :Students
    @user = User.new
    @school = School.find(params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student }
    end
  end
  
  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
  end
  
  # POST /students
  # POST /students.xml
  def create
    @school = School.find(params[:school_id])
    @user = User.new(params[:user])
    if(@user.save)
      puts "user save"
      @student = Student.new
      @student.user = @user
      @user.person = @student
      @student.school = @school
      if @student.save
        flash[:notice] = "Account registered!"
        redirect_back_or_default @school
      else
        render :action => :new
      end
    else
      puts "user save else"
      render :action => :new
    end  
  end
  
  def add_student    
    @school = School.find(params[:school_id])
    if(params[:email])
      @user = User.find_by_email_and_person_type(params[:email], 'Student')
      if @user.nil?
        render :update do |page|
          page[:password].show
          page[:add_student_button].disable
        end
      else
        @student = @user.person
        @student.school = @school
        if @student.save
          flash[:notice] = "Account registered!"
          render :update do |page|
            page.redirect_to @school
          end
        end
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
    @student.destroy
    
    respond_to do |format|
      format.html { redirect_to(students_url) }
      format.xml  { head :ok }
    end
  end
  
  def auto_complete_for_user_email
    find_options = { 
      :conditions => [ "LOWER(#{:email}) LIKE ? AND person_type = ?", params[:user][:email].downcase + '%' , 'Student'], 
      :order => "#{:email} ASC",
      :limit => 10 }    
    @items = User.find(:all, find_options)   
    render :inline => "<%= auto_complete_result @items, '#{:email}' %>"
  end
  
  def self.tabs(student_id)
    tabs = [:Home => {:controller => :students, :action => 'show', :id=>student_id},
    :Subjects => '#',
    :Messages => '#',
    :Calendar => '#',    
    :Leave => '#',
    :Exams => '#',
    :Scores => '#',
    :AcademicHistory => '#',
    :Profile =>  {:controller => :user_profiles, :action => 'profile_edit', :id=>student_id} ]
    return tabs
  end
end
