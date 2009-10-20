class SchoolsController < ApplicationController
  #skip_before_filter :require_user, :only => :index
  
  #permit "creator of Student", :except => :index
  protect_from_forgery :only => [:create, :update, :destroy]
  # GET /schools
  # GET /schools.xml
  def index
    @active_tab = :Home
    @schools = School.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
  end
  
  # GET /schools/1
  # GET /schools/1.xml
  def show
    @active_tab = :Home
    @school=School.find(params[:id])
    set_active_user(@school.user)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school }
    end
  end
  
  
  # GET /schools/new
  # GET /schools/new.xml
  def new
    @school = School.new
    
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
    
    respond_to do |format|
      if @school.save
        flash[:notice] = 'School was successfully created.'
        format.html { redirect_to(@school) }
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
    @school.destroy
    
    respond_to do |format|
      format.html { redirect_to(schools_url) }
      format.xml  { head :ok }
    end
  end
  
  def profile_new
    @school=School.find(params[:id])
    @user=@school.user
    @user_profile = UserProfile.new
  end
  
  def profile_create
    @school=School.find(params[:id])
    @user=@school.user
    @user_profile = UserProfile.new(params[:user_profile])
    @user_profile.user=@user
    User.transaction do
      @school.update_attributes!(params[:school]) 
      @user_profile.save!
      @user.update_attributes!(params[:user])
    end
    flash[:notice] = 'Profile was successfully created.'
    redirect_to(url_for( :controller => :schools, :action => 'profile_show', :id=>@school))
  rescue Exception => e
    flash[:notice]="Error occured in profile creation: <br /> #{e.message}"
    redirect_to(url_for( :controller => :schools, :action => 'profile_show', :id=>@school)) 
  end
  
  def profile_show
    @active_tab = :Profile
    @school=School.find(params[:id])
    @user=@school.user
    if @user.user_profile.nil?
      redirect_to(url_for( :controller => :schools, :action => 'profile_new', :id=>@school))
    end
    @user_profile=@user.user_profile
  end
  
  # GET /schools/1/edit
  def profile_edit
    @active_tab = :Profile    
    @school=School.find(params[:id])
    @user=@school.user
    @user_profile=@user.user_profile
  end
  
  def profile_update
    @active_tab = :Profile
    @school=School.find(params[:id])
    @user=@school.user
    @user_profile=@user.user_profile
    User.transaction do
      @school.update_attributes!(params[:school]) 
      @user_profile.update_attributes!(params[:user_profile])
      @user.update_attributes!(params[:user])
    end
    flash[:notice] = 'Profile was successfully updated.'
    redirect_to(url_for( :controller => :schools, :action => 'profile_show', :id=>@school)) 
  rescue Exception => e
    flash[:notice]="Error occured in profile update: <br /> #{e.message}"
    redirect_to(url_for( :controller => :schools, :action => 'profile_edit', :id=>@school)) 
  end
  
  def teachers_index
    @active_tab = :Teachers
    @school=School.find(params[:id])
    @teachers=@school.teachers
    if @teachers.empty?
      flash[:notice] = 'No teacher exists.'
      #   redirect_to(url_for( :controller => :schools, :action => 'teacher_new', :id=>@school))
    end
    @year = Klass.current_academic_year(@school)
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
  end
  
  def add_school_teacher
    @school=School.find(params[:id])
    @user = User.find(:first, :conditions => ["email = ?",params[:user][:email]])
    if @user.nil?
      flash[:notice] = "The user does not exist"
    else
      @school.teachers << @user.person
    end
  end
  
  def auto_complete_for_user_email
    puts params[:user][:email]
    find_options = { 
      :conditions => [ "LOWER(#{:email}) LIKE ? AND person_type = ?", params[:user][:email].downcase + '%' , 'Teacher'], 
      :order => "#{:email} ASC",
      :limit => 10 }    
    @items = User.find(:all, find_options)   
    render :inline => "<%= auto_complete_result @items, '#{:email}' %>"
  end
  
  
  def klasses
    @active_tab = :Classes
    @school=School.find(params[:id])
    @year = Klass.current_academic_year(@school)
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
    @school_subjects = @school.subjects
    @add_subjects = Subject.find(:all) -  @school_subjects
  end
  
  def list_delete_klasses   
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
  end
  
  def delete_klasses
    delete_klasses = params[:delete_klasses].split(',')
    delete_klasses.each {|klass_id| 
      if (!klass_id.empty?) 
        Klass.destroy(klass_id.to_i)
      end
    }  
    @school=School.find(params[:id])
    @year = Klass.current_academic_year(@school)
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
  end
  
  def delete_subject
    @school = School.find(params[:id])
    subject = @school.subjects.find(params[:subject_id])
    if(subject)
      @school.subjects.delete(subject)
      @school.save
    end
    @all_subjects = Subject.find(:all)
    @school_subjects = @school.subjects
    @add_subjects = @all_subjects - @school.subjects
    render :update do |page|
      page.replace_html("school_subjects_list", :partial =>'schools/subjects_list' , :object=>@school_subjects)
      page.replace_html("school_add_subjects_list", :partial =>'schools/subjects', :object=>@add_subjects )
    end
  end
  
  def list_add_subjects
    @school = School.find(params[:id])
    @all_subjects = Subject.find(:all)
    puts "in list add - schools - "+@all_subjects.inspect
    @add_subjects = @all_subjects - @school.subjects
  end
  
  def add_subjects
    @school = School.find(params[:id])
    add_subjects = params[:school_add_subjects].split(',')
    add_subjects.each {|subject_id| 
      if (!subject_id.empty?)
        subject = Subject.find(subject_id.split('_').last)
        @school.subjects << subject
      end
    }  
    @school_subjects = @school.subjects
    @add_subjects = Subject.find(:all) - @school_subjects
  end
  
  def self.tabs(school_id)
    tabs = [:Home => {:controller => :schools, :action => 'show', :id=>school_id},#schools_path,
    :Classes => {:controller => :schools, :action => 'klasses', :id=>school_id},
    :Teachers => {:controller => :schools, :action => 'teachers_index', :id=>school_id} ,#'teachers_path',
    :Students => '#',
    :Departments => '#',
    :Profile =>  {:controller => :user_profiles, :action => 'profile_show', :id=>school_id} ]
    return tabs
  end
  
end
