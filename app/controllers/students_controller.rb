class StudentsController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  
  protect_from_forgery :only => [:create, :update, :destroy] 
  
  
  def self.in_place_loader_for(object, attribute, options = {})
    define_method("get_#{object}_#{attribute}") do
      @item = object.to_s.camelize.constantize.find(params[:id])
      render :text => (@item.send(attribute).blank? ? "[No Name]" : @item.send(attribute))
    end
  end  
  
  in_place_loader_for :student, :admission_number
  in_place_edit_for :student, :admission_number
  
  in_place_loader_for :student, :roll_number
  in_place_edit_for :student, :roll_number
  
  
  def show
    session[:redirect] = request.request_uri
    @student = Student.find(params[:id])
    @school = @student.school
    @klass = @student.klass
    if @school    
      if @klass
        @all_subjects = Subject.find(:all, :order => 'name')
        @exams = @student.exams
      else
        @klasses = @school.klasses
      end
    end
    @user=@student.user
  end
  
  
  def new
    @student = Student.new
    @user = User.new
  end 
  

  def create
    #    TODO - if the user already exists, with school not assigned, we should let that be added to school after enough warnings    
    @student = Student.new(params[:student])
    if(params[:school_id])
      @school = School.find(params[:school_id])
      @student.school = @school
    end    
    @user = User.new(params[:user])
    @user.person = @student
    @user.user_profile = UserProfile.new(params[:user_profile])
    if @user.deliver_invitation!
      @users = get_users_for_composing(@student.school).flatten if @student.school
      render :template => 'students/create_success'
    else  
      render :template => 'students/create_error'      
    end
  end
  
  
  def edit
    @student = Student.find(params[:id]) 
  end
  
  
  # TODO page context
  # Called from students/show and klass/student. Need to update breadcrumbs for the first
  def update
    @student = Student.find(params[:id])
    if(@student.update_attributes(params[:student]))    
      #    TODO redesign this when we do wizard flows for right-bar actions
      if(session[:redirect]) and session[:redirect] == student_path(@student)
        render :update do |page|
          page.redirect_to session[:redirect]
        end
      else
        render :template => 'students/update_success'
      end
    else
      render :template => 'students/update_failure'
    end
  end
  
  def edit_papers
    @student  = Student.find(params[:id])  
    @klass = @student.klass
  end
  
  def update_papers
    @student = Student.find(params[:id])
    @student.paper_ids = params[:paper_ids]
    @student.save!
  end
  
  def add_to_school
    @student = Student.find(params[:id])
    @school = School.find(params[:student][:school_id])
    @school.students << @student
    @school.save!
    render :update do |page|
      page.redirect_to student_path(@student)
    end
  end
  
end
