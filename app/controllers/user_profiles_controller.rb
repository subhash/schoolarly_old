class UserProfilesController < ApplicationController
  
  before_filter :find_user_and_person, :except => :add_qualification
  before_filter :set_up, :only => [:show, :new, :edit]
  
  def find_user_and_person    
    if(params[:id])
      @user=User.find(params[:id])
      @person=@user.person
    end
  end  
  
  def set_up
    set_active_user(@user.id)
    case @user.person_type
      when 'Teacher'  
        if @person.school
          add_breadcrumb(@person.school.name, @person.school)
        end
        add_breadcrumb(@person.name, @person)
      when 'Student'
        if @person.school
          add_breadcrumb(@person.school.name, @person.school)
          if @person.current_klass
            add_breadcrumb(@person.current_klass.name, @person.current_klass)
          end
        end
        add_breadcrumb(@person.name, @person)
      when 'School'
        add_breadcrumb((@person.name.nil?)? @user.email : @person.name, @person)
    end
  end
  
  def new
    if @user != current_user
      redirect_to(url_for( :controller => :user_profiles, :action => 'show', :id=>@user))
    else 
      if @user.user_profile
        redirect_to(url_for( :controller => :user_profiles, :action => 'edit', :id=>@user))
      end
      add_breadcrumb('Profile')
      @user_profile = UserProfile.new
    end
  end
  
  def create
    @user_profile = UserProfile.new(params[:user_profile])
    @user_profile.user=@user
    person_type=@user.person_type.to_s.downcase
    User.transaction do
      if @user.is_a?(Teacher)
        if params[:qualification]
          Qualification.update(params[:qualification].keys, params[:qualification].values)
        end
        if params[:cb]
          qualifications_marked_for_deletion=Qualification.find(params[:cb].keys)
          Qualification.destroy(qualifications_marked_for_deletion)
        end
      else
        @person.update_attributes!(params[person_type])
      end
      @user_profile.save!
      @user.update_attributes!(params[:user])
    end
    flash[:notice] = 'Profile was successfully created.'
    redirect_to(url_for( :controller => :user_profiles, :action => 'show', :id=>@user))
  rescue Exception => e
    flash[:notice]="Error occurred in profile creation: <br /> #{e.message}"
    redirect_to(url_for( :controller => :user_profiles, :action => 'new', :id=>@user)) 
  end
  
  def show
    if @user.user_profile.nil? and @user == current_user
      redirect_to(url_for( :controller => :user_profiles, :action => 'new', :id=>@user))
    end
    add_breadcrumb('Profile')
    if @user == current_user
      add_page_action('Edit', {:controller => :user_profiles, :action => 'edit', :id => @user})
    end
    @user_profile=@user.user_profile
  end
  
  def edit
    if @user != current_user
      redirect_to(url_for( :controller => :user_profiles, :action => 'show', :id=>@user))
    else    
      if @user.user_profile.nil? 
        redirect_to(url_for( :controller => :user_profiles, :action => 'new', :id=>@user))
      end
      add_breadcrumb('Profile', {:controller => :user_profiles, :action => 'show', :id => @user})
      add_breadcrumb('Edit')
      @user_profile=@user.user_profile
    end
  end
  
  def update
    @user_profile=@user.user_profile
    person_type=@user.person_type.to_s.downcase
    User.transaction do
      if @person.is_a?(Teacher)
        if params[:qualification]
          Qualification.update(params[:qualification].keys, params[:qualification].values)
        end
        if params[:cb]
          qualifications_marked_for_deletion=Qualification.find(params[:cb].keys)
          Qualification.destroy(qualifications_marked_for_deletion)
        end
      else
        @person.update_attributes!(params[person_type])
      end
      @user_profile.update_attributes!(params[:user_profile])
      @user.update_attributes!(params[:user])
    end
    flash[:notice] = 'Profile was successfully updated.'
    redirect_to(url_for( :controller => :user_profiles, :action => 'show', :id=>@user)) 
  end
  
  def add_qualification
    @person=Teacher.find(params[:id])
    @qualification=Qualification.new()
    @qualification.university=params[:university]
    @qualification.degree=params[:degree]
    @qualification.subject=params[:subject]
    @qualification.date=params[:date]
    @qualification.teacher = @person
    @person.qualifications << @qualification
    respond_to do |format|
      flash[:notice] = 'Qualification details were successfully added.'
      format.js {render :template => 'user_profiles/qualification_create_success'}
    end
  rescue Exception => e
    respond_to do |format|
      format.js {render :template => 'user_profiles/qualification_create_error'}
    end
  end

end