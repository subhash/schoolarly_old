class UserProfilesController < ApplicationController
  
  before_filter :set_active_tab
  before_filter :find_user_and_person, :except => :add_qualification
  
  def set_active_tab
    @active_tab = :Profile
  end
  
  def find_user_and_person    
    if(params[:id])
      @user=User.find(params[:id])
      @person=@user.person
    end
  end  
  
  def new
    set_active_user(@user.id)
    @user_profile = UserProfile.new
    @person_partial=@user.person_type.to_s.downcase
  end
  
  def create
    @user_profile = UserProfile.new(params[:user_profile])
    @user_profile.user=@user
    person_type=@user.person_type.to_s.downcase
    User.transaction do
      @person.update_attributes!(params[person_type]) 
      @user_profile.save!
      @user.update_attributes!(params[:user])
    end
    flash[:notice] = 'Profile was successfully created.'
    redirect_to(url_for( :controller => :user_profiles, :action => 'show', :id=>@user))
  rescue Exception => e
    flash[:notice]="Error occured in profile creation: <br /> #{e.message}"
    redirect_to(url_for( :controller => :user_profiles, :action => 'show', :id=>@user)) 
  end
  
  def show
    set_active_user(@user.id)
    if @user.user_profile.nil?
      redirect_to(url_for( :controller => :user_profiles, :action => 'new', :id=>@user))
    end
    @user_profile=@user.user_profile
    @person_partial=@user.person_type.to_s.downcase
  end
  
  def edit
    set_active_user(@user.id)
    @user_profile=@user.user_profile
    @person_partial=@user.person_type.to_s.downcase    
  end
  
  def update
    @user_profile=@user.user_profile
    person_type=@user.person_type.to_s.downcase
    User.transaction do
      if person_type=="teacher"
        Qualification.update(params[:qualification].keys, params[:qualification].values)
      else
        @person.update_attributes!(params[person_type])
      end
      @user_profile.update_attributes!(params[:user_profile])
      @user.update_attributes!(params[:user])
    end
    flash[:notice] = 'Profile was successfully updated.'
    redirect_to(url_for( :controller => :user_profiles, :action => 'show', :id=>@user)) 
  rescue Exception => e
    flash[:notice]="Error occured in profile update: <br /> #{e.message}"
    redirect_to(url_for( :controller => :user_profiles, :action => 'edit', :id=>@user)) 
  end
  
  def add_qualification
    @person=Teacher.find(params[:id])
    qualification=Qualification.new()
    qualification.university=params[:university]
    qualification.degree=params[:degree]
    qualification.subject=params[:subject]
    qualification.date=params[:date]
    @person.qualifications << qualification
    @person.save!
  rescue Exception => e
    flash[:notice]="Error occured in qualification add: <br /> #{e.message}"
  end
end
