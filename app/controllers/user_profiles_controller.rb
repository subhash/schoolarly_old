class UserProfilesController < ApplicationController
  
  def profile_new
    @user=User.find_by_person_id(params[:id])
    @person=@user.person
    @user_profile = UserProfile.new
    @person_partial=@user.person_type.to_s.downcase
  end
  
  def profile_create
    @user=User.find_by_person_id(params[:id])
    @person=@user.person
    @user_profile = UserProfile.new(params[:user_profile])
    @user_profile.user=@user
    person_type=@user.person_type.to_s.downcase
    User.transaction do
      @person.update_attributes!(params[person_type]) 
      @user_profile.save!
      @user.update_attributes!(params[:user])
    end
    flash[:notice] = 'Profile was successfully created.'
    redirect_to(url_for( :controller => :user_profiles, :action => 'profile_show', :id=>@person))
  rescue Exception => e
    flash[:notice]="Error occured in profile creation: <br /> #{e.message}"
    redirect_to(url_for( :controller => :user_profiles, :action => 'profile_show', :id=>@person)) 
  end
  
  def profile_show
    @active_tab = :Profile
    @user=User.find_by_person_id(params[:id])
    @person=@user.person
    if @user.user_profile.nil?
      redirect_to(url_for( :controller => :user_profiles, :action => 'profile_new', :id=>@person))
    end
    @user_profile=@user.user_profile
  end
  
  def profile_edit
    @active_tab = :Profile    
    @user=User.find_by_person_id(params[:id])
    @person=@user.person
    @user_profile=@user.user_profile
    @person_partial=@user.person_type.to_s.downcase    
  end
  
  def profile_update
    @active_tab = :Profile
    @user=User.find_by_person_id(params[:id])
    @person=@user.person
    @user_profile=@user.user_profile
    person_type=@user.person_type.to_s.downcase
    User.transaction do
      @person.update_attributes!(params[person_type])
      @user_profile.update_attributes!(params[:user_profile])
      @user.update_attributes!(params[:user])
    end
    flash[:notice] = 'Profile was successfully updated.'
    redirect_to(url_for( :controller => :user_profiles, :action => 'profile_show', :id=>@person)) 
  rescue Exception => e
    flash[:notice]="Error occured in profile update: <br /> #{e.message}"
    redirect_to(url_for( :controller => :user_profiles, :action => 'profile_edit', :id=>@person)) 
  end
  
end
