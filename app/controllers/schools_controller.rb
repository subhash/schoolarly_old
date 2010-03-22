class SchoolsController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  #permit "creator of Student", :except => :index

  
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
    add_js_page_action(:title => 'Add class',:render => {:partial => 'klasses/new_klass_form', :locals => {:klass => Klass.new, :school => @school}})
    add_js_page_action(:title => 'Invite Student',:render => {:partial => 'students/invite_student_form', :locals => {:student => Student.new, :school => @school}})
    add_js_page_action(:title => 'Invite Teacher',:render => {:partial => 'teachers/invite_teacher_form', :locals => {:teacher => Teacher.new, :school => @school}})
    @klasses = @school.klasses.group_by{|klass|klass.level}
    @exam_groups = @school.exam_groups.group_by{|eg| Klass.find(eg.klass_id)}
    @students = @school.students
    @teachers = @school.teachers
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

  def remove_teacher
    @teacher = Teacher.find(params[:id])
    @school = @teacher.school
    if(!@teacher.current_klass_allotments.empty? && !@teacher.current_klass_allotments.nil?)
      @teacher.current_klass_allotments.each do |allotment|
        allotment.end_date = Time.now.to_date
      end
    end
    @teacher.save!
    @school.teachers.delete(@teacher)
    @school.save!
    respond_to do |format|
      format.js {render :template => 'teachers/remove'}
    end 
  end
  
  def edit_teacher
    @teacher = Teacher.find(params[:id])
    respond_to do |format|
      format.js {render :template => 'teachers/edit'}
    end  
  end

  def add_subjects
    if params[:entity_klass] == 'Teacher'
      @teacher = Teacher.find(params[:id])
      subjects_to_add = Subject.find(params[:teacher][:subject_ids].compact.reject(&:blank?)) - @teacher.current_subjects
      subjects_to_remove = @teacher.current_subjects - @teacher.allotted_subjects - Subject.find(params[:teacher][:subject_ids].compact.reject(&:blank?))
      subjects_to_add.each do |subject|
        @teacher.teacher_subject_allotments << TeacherSubjectAllotment.new(:school => @teacher.school, :subject => subject)
      end
      TeacherSubjectAllotment.destroy(@teacher.current_subject_allotments.select{|allotment| subjects_to_remove.include?(allotment.subject)}.collect{|alltmnt| alltmnt.id })
      @teacher.reload
    end
    template_name = 'schools/add_subjects_to_' + params[:entity_klass].downcase
    respond_to do |format|
      format.js {render :template => template_name}
    end 
  end  
  
end
