class SchoolsController < ApplicationController
  #skip_before_filter :require_user, :only => :index
  
  #permit "creator of Student", :except => :index
  
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
  
  def klasses
    @active_tab = :Classes
    @school=School.find(params[:id])
    @year = Klass.current_academic_year(@school)
    @klasses = Klass.current_klasses(@school, @year)
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
