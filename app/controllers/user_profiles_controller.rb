class UserProfilesController < ApplicationController
  
  before_filter :find_user_and_person
  before_filter :set_up, :only => [:show, :new, :edit]
  after_filter :store_parent_url, :only => [:show, :new, :edit]
 
   def self.in_place_loader_for(object, attribute, options = {})
    define_method("get_#{object}_#{attribute}") do
      @item = object.to_s.camelize.constantize.find(params[:id])
      render :text => (@item.send(attribute).blank? ? "[No Name]" : @item.send(attribute))
    end
  end  
  
  in_place_loader_for :user_profile, :name
  in_place_edit_for :user_profile, :name
  
  in_place_loader_for :user_profile, :address_line_1
  in_place_edit_for :user_profile, :address_line_1
  
  in_place_loader_for :user_profile, :address_line_2
  in_place_edit_for :user_profile, :address_line_2
  
  in_place_loader_for :user_profile, :city
  in_place_edit_for :user_profile, :city

  in_place_loader_for :user_profile, :state
  in_place_edit_for :user_profile, :state
  
  in_place_loader_for :user_profile, :country
  in_place_edit_for :user_profile, :country
  
  in_place_loader_for :user_profile, :pincode
  in_place_edit_for :user_profile, :pincode
  
  in_place_loader_for :user_profile, :phone_landline
  in_place_edit_for :user_profile, :phone_landline
  
  in_place_loader_for :user_profile, :phone_mobile
  in_place_edit_for :user_profile, :phone_mobile
  
  def find_user_and_person    
    if(params[:id])
      @user=User.find(params[:id])
      @person=@user.person
    end
  end  
  
  def set_up
    set_active_user(@user.id)
  end
  
  def store_parent_url
    session[:parent_url] = request.request_uri
  end
  
  def new
    if @user != current_user
      redirect_to(url_for( :controller => :user_profiles, :action => 'show', :id=>@user))
    else 
      if !@user.user_profile.nil?
        redirect_to(url_for( :controller => :user_profiles, :action => 'edit', :id=>@user))
      end
      @user_profile = UserProfile.new
    end
  end
  
  def create
    @user_profile = UserProfile.new(params[:user_profile])
    @user_profile.user=@user
    User.transaction do
      @person.update_attributes!(params[:person])
      @user_profile.save!
      @user.update_attributes!(params[:user])
    end
    flash[:notice] = 'Profile was successfully created.'
    redirect_to(url_for( :controller => :user_profiles, :action => 'show', :id=>@user))
  end
  
  def show
#    if @user.user_profile.nil? and @user == current_user 
#      redirect_to(url_for( :controller => :user_profiles, :action => 'new', :id=>@user))
#    end    
    @user_profile=@user.user_profile
  end
  
  def edit
#    if @user != current_user
#      redirect_to(url_for( :controller => :user_profiles, :action => 'show', :id=>@user))
#    else    
      if @user.user_profile.nil? 
        redirect_to(url_for( :controller => :user_profiles, :action => 'new', :id=>@user))
      else
        @user_profile=@user.user_profile
      end
#    end
  end
  
  def update
    @user_profile=@user.user_profile
    User.transaction do
      @person.update_attributes!(params[:person])
      @user_profile.update_attributes!(params[:user_profile])
      @user.update_attributes!(params[:user])
    end
    flash[:notice] = 'Profile was successfully updated.'
    redirect_to(url_for(:controller => :user_profiles, :action => 'show', :id=>@user))
  end

end