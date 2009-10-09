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
    @active_tab = :Profile
    @school = School.find(params[:id])
    @user=@school.user#User.find_by_person_id(params[:id])
    @user_profile=@user.user_profile
    respond_to do |format|
      if @school.update_attributes(params[:school]) && @user.update_attributes(params[:user]) && @user_profile.update_attributes(params[:user_profile])
        flash[:notice] = 'School was successfully updated.'
        format.html { redirect_to(url_for( :controller => :schools, :action => 'profile', :id=>@user)) }
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
    #@user = User.find(params[:id])
    #@school = @user.person
    @school=School.find(params[:id])
    @user=@school.user
    @user_profile = UserProfile.new
    respond_to do |format|
      format.html # profile_new.html.erb
      format.xml  { render :xml => @user_profile }
    end
  end
  
  def profile_create
    #@user = User.find(params[:id])
    #@school = @user.person
    @school=School.find(params[:id])
    @user=@school.user
    @user_profile = UserProfile.new(params[:user_profile])
    @user_profile.user=@user
    respond_to do |format|
      if @user_profile.save! && @user.update_attributes(params[:user]) && @school.update_attributes(params[:school])
        flash[:notice] = 'Profile was successfully created.'
        format.html { redirect_to(url_for( :controller => :schools, :action => 'profile_show', :id=>@school)) }
        # format.xml  { render :xml => @user_profile, :status => :created, :location => @school }
      else
        format.html { render :action => "profile_new" }
        #  format.xml  { render :xml => @user_profile.errors, :status => :unprocessable_entity }
      end
    end
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
    respond_to do |format|
      if @school.update_attributes(params[:school]) && @user.update_attributes(params[:user]) && @user_profile.update_attributes(params[:user_profile])
        @user.user_profile = @user_profile
        flash[:notice] = 'Profile was successfully updated.'
        format.html { redirect_to(url_for( :controller => :schools, :action => 'profile_show', :id=>@school)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "profile_edit" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def klasses
    @active_tab = :Classes
    @school=School.find(params[:id])
    @year = Klass.current_academic_year(@school)
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
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
  
  def self.tabs(school_id)
    tabs = [:Home => {:controller => :schools, :action => 'show', :id=>school_id},#schools_path,
    :Classes => {:controller => :schools, :action => 'klasses', :id=>school_id},
    :Teachers => '#',#'teachers_path',
    :Students => '#',
    :Profile =>  {:controller => :schools, :action => 'profile_show', :id=>school_id} ]
    return tabs
  end
  
end
