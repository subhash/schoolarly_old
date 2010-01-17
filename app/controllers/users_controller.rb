class UsersController < ApplicationController
  skip_before_filter :require_user, :except => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @person_type = params[:person_type]
    person_class = Object.const_get(@person_type)
    @user.person = person_class.new
    if @user.save
      respond_to do |format|
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_back_or_default account_url }
        format.js {render :template => 'users/create_success'}
      end     
    else
      respond_to do |format|          
        format.html { render :action => "new" }
        format.js {render :template => 'users/create_error'}
      end
    end
  end
  
  def show
    @user = current_user
    set_active_user(@user.id)
    @users = User.find(:all)
  end
  
  def edit
    @user = @current_user
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.person.destroy
    @user.destroy    
    redirect_to users_path(:user_type => :user)
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
    add_breadcrumb('Home')
    add_js_page_action('Invite Student',:partial => 'students/invite_student_form', :locals => {:student => Student.new, :school => @school})
    add_js_page_action('Invite Teacher',:partial => 'teachers/invite_teacher_form', :locals => {:teacher => Teacher.new, :school => @school})
    add_js_page_action('Add Student',:partial => 'users/new_user', :locals => {:user => User.new, :person_type => 'Student'})
    add_js_page_action('Add Teacher',:partial => 'users/new_user', :locals => {:user => User.new, :person_type => 'Teacher'})
    
    @schools = User.find_all_by_person_type(:School)
    @students = Student.find(:all)
    @teachers = Teacher.find(:all)
    # XXX Hack - Get only current allotments
    @subjects = TeacherAllotment.find(:all).group_by{|a| a.teacher_id}
  end
  
  
  def navigation_tabs
    tabs = [:Users => users_path(:user_type => :user),
    :Schools => users_path(:user_type => :school),
    :Teachers => users_path(:user_type => :teacher),
    :Students => users_path(:user_type => :student)]
    
    return tabs
  end
  
  
  def roles
    flash[:notice]=(params[:user].inspect)
    puts params[:user].inspect
    for u in params[:user]
      puts u.inspect
    end
    redirect_to :action => :show, :id => params[:id]
  end
  
  def remove_student
    @student = Student.find(params[:id])
    Student.transaction do
      @student.user.destroy
      @student.destroy
    end
  end
  
end