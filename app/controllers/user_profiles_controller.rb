class UserProfilesController < ApplicationController
  
  before_filter :find_user_and_person
 
  in_place_edit_for :user_profile, :name
  in_place_edit_for :user_profile, :address_line_1
  in_place_edit_for :user_profile, :address_line_2
  in_place_edit_for :user_profile, :city
  in_place_edit_for :user_profile, :state
  in_place_edit_for :user_profile, :country
  in_place_edit_for :user_profile, :pincode
  in_place_edit_for :user_profile, :phone_landline
  in_place_edit_for :user_profile, :phone_mobile
  in_place_edit_for :user, :email
  
  def find_user_and_person    
    if(params[:id])
      @user=User.find(params[:id])
      @person=@user.person
    end
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