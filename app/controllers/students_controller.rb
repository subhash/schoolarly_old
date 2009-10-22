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
    set_active_user(@student.user.id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end
  
  # GET /students/new
  # GET /students/new.xml
  def new
  
  end
  
  # GET /students/1/edit
  def edit
    @student = Student.find(params[:id])
  end
  
  # POST /students
  # POST /students.xml
  def create

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
    user_id=Student.find(student_id).user.id
    tabs = [:Home => {:controller => :students, :action => 'show', :id=>student_id},
    :Subjects => '#',
    :Messages => '#',
    :Calendar => '#',    
    :Leave => '#',
    :Exams => '#',
    :Scores => '#',
    :AcademicHistory => '#',
    :Profile =>  {:controller => :user_profiles, :action => 'edit', :id=>user_id} ]
    return tabs
  end
end
