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
        format.js {
          render_success :object => @user.person, :insert => {:partial => "#{@person_type.underscore.pluralize}/#{@person_type.underscore}", :object => @user.person} 
        }
      end     
    else
      respond_to do |format|          
        format.html { render :action => "new" }        
        format.js {
          #{render :template => 'users/create_error'}
          render_failure :refresh => {:partial => 'users/new_user', :locals => {:user => @user, :person_type => @person_type}}
        }
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
    session[:redirect] = request.request_uri
    add_breadcrumb('Home')
    add_js_page_action(:title => 'Invite Student',:render => {:partial => 'students/invite_student_form', :locals => {:student => Student.new, :school => @school}})
    add_js_page_action(:title => 'Invite Teacher',:render => {:partial => 'teachers/invite_teacher_form', :locals => {:teacher => Teacher.new, :school => @school}})
    add_js_page_action(:title => 'Add Student',:render => {:partial => 'users/new_user', :locals => {:user => User.new, :person_type => 'Student'}})
    add_js_page_action(:title => 'Add Teacher',:render => {:partial => 'users/new_user', :locals => {:user => User.new, :person_type => 'Teacher'}})
    add_js_page_action(:title => 'Add School',:render => {:partial => 'users/new_user', :locals => {:user => User.new, :person_type => 'School'}})
    
    @schools = School.find(:all)
    @students = Student.find(:all)
    @teachers = Teacher.find(:all)
  end
  
  def remove_student
    @student = Student.find(params[:id])
    Student.transaction do
      @student.user.destroy
      @student.destroy
    end
  end
  
  def remove_teacher
    @teacher = Teacher.find(params[:id])
    Teacher.transaction do
      @teacher.user.destroy
      @teacher.destroy
    end
    @teachers=Teacher.all
    respond_to do |format|
      format.js {render :template => 'teachers/remove'}
    end 
  end
  
end