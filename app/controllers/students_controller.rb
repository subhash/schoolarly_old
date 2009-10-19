class StudentsController < ApplicationController
  # GET /students
  # GET /students.xml
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
    @student = Student.new
    
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
    @student = Student.new(params[:student])
    
    respond_to do |format|
      if @student.save
        flash[:notice] = 'Student was successfully created.'
        format.html { redirect_to(@student) }
        format.xml  { render :xml => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student.errors, :status => :unprocessable_entity }
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
  
  def profile_edit
    @active_tab = :Profile    
    @student=Student.find(params[:id])
    @user=@student.user
    @user_profile=@user.user_profile
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
    :Profile =>  {:controller => :students, :action => 'profile_edit', :id=>student_id} ]
    return tabs
  end
end
