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
    @user=User.find(params[:id])
    @school=@user.person
    #@klasses=@school.klasses
    #@teachers=@school.teachers
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
    @user = User.find(params[:id])
    @school = @user.person
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
    @user=User.find_by_person_id(params[:id])
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
  
  def profile
    @active_tab = :Profile
    @user=User.find(params[:id])
    @school=@user.person
    @user_profile=@user.user_profile
  end
  
  def klasses
    @active_tab = :Classes
    @school=School.find(params[:id])
    @year = Klass.current_academic_year(@school)
    @klasses = Klass.current_klasses(@school, @year)
  end
  
  def navigation_tabs
    tabs = [:Home => {:controller => :schools, :action => 'show', :id=>@user},#schools_path,
    :Classes => {:controller => :schools, :action => 'klasses', :id=>@user},
    :Teachers => '#',#'teachers_path',
    :Students => '#',
    :Profile =>  {:controller => :schools, :action => 'profile', :id=>@user} ]
    return tabs
  end
  
end
