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
    user_type = params[:user_type]   
    
    if user_type == School.name.downcase
      @users = User.find_all_by_person_type(:School)
      @active_tab = :Schools
    elsif user_type == Teacher.name.downcase
      puts "in teacher"
      @users = User.find_all_by_person_type(:Teacher)
      @active_tab = :Teachers
    elsif user_type == Student.name.downcase
      @users = User.find_all_by_person_type(:Student)
      @active_tab = :Students
    else
      @users = User.find(:all)
      @active_tab = :Users
    end
    
  end
    
  
  def navigation_tabs
    tabs = [:Users => users_path(:user_type => :user),
    :Schools => users_path(:user_type => :school),
    :Teachers => users_path(:user_type => :teacher),
    :Students => users_path(:user_type => :student)]
    
    return tabs
  end
end