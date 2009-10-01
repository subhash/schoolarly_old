class UsersController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    person_class = Object.const_get(params[:user_type])
    @user.person = person_class.new
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    
  end
  
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  def index
    @users = User.find(:all)
  end
  
  def navigation_tabs
    tabs = [:Home => schools_path,
    :Classes => school_klasses_path(@school),
    :Teachers => teachers_path,
    :Students => '#',
    :Profile =>  {:action => 'profile', :id=>1}]
    
    return tabs
  end
end