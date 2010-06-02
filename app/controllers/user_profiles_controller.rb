class UserProfilesController < ApplicationController
  
  before_filter :find_user_and_person
 
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
  
  def show
    @user_profile=@user.user_profile
  end

  def update
    @user.password = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation]  
    if @user.save
      render :template => 'user_profiles/change_password_success'
    else
      render :template => 'user_profiles/change_password_failure'
    end
  end
  
end