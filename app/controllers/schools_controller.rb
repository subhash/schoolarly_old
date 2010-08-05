class SchoolsController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  #permit "creator of Student", :except => :index
  
  in_place_edit_for :school, :board
  in_place_edit_for :school, :fax
  in_place_edit_for :school, :website
  
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
    @user=@school.user
    @klasses = @school.klasses.group_by{|klass|klass.level_id}
    @students = @school.students
    @teachers = @school.teachers
    @user_profile = @user.user_profile
    @school_user_ids = @school.users.collect{|u| u.id}
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
    @school.set_academic_year
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
  
  def edit_academic_year
    @school = School.find(params[:id])
    @academic_year = @school.academic_year
  end
  
  def update_academic_year
    @school = School.find(params[:school_id])
    @academic_year = @school.academic_year
    @academic_year.attributes = params[:academic_year]
    if test_date(:academic_year, 'start_date') && test_date(:academic_year, 'end_date')
      if @academic_year.save
        render :template => 'schools/update_academic_year_success'
      else
        render :template => 'schools/update_academic_year_failure'
      end
    else
      @academic_year.errors.add(:academic_year, ': Invalid date selected' )
      render :template => 'schools/update_academic_year_failure'  
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
  
  def remove_teacher
    @teacher = Teacher.find(params[:id])
    @school = @teacher.school
    if !@teacher.papers.empty?
      @teacher.papers.each do |paper|
        paper.teacher = nil
        paper.save!
      end
    end
    @school.teachers.delete(@teacher)
    @school.save!
    @teachers=@school.teachers
    render :template => 'teachers/remove'
  end
  
  def remove_student
    @student = Student.find(params[:id])
    @school = @student.school
    @student.papers.delete_all
    @student.klass = nil
    @student.school = nil
    @student.save!
    respond_to do |format|
      format.js {render :template => 'schools/remove_student'}
    end 
  end
  
  def add_subjects
    @school = School.find(params[:id])
    @school.subject_ids = params[:subject_ids]    
    render :update do |page|
      if @school.save
        page.replace_tab :subjects, :partial => 'subjects/subjects', :object => @school.subjects
        page.replace_action 'Add Subjects', :partial => 'schools/add_subjects', :locals => {:school => @school, :subjects => Subject.all}
        page.close_dialog        
      else
        page.refresh_dialog :partial => 'schools/add_subjects', :locals => {:school => @school, :subjects => Subject.all}
      end
    end    
  end
  
end
