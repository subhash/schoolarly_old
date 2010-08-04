class StudentsController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  
  protect_from_forgery :only => [:create, :update, :destroy] 
  
  in_place_edit_for :student, :date_of_birth
  in_place_edit_for :student, :fathers_name
  in_place_edit_for :student, :mothers_name
  in_place_edit_for :student, :board_registration_number
  in_place_edit_for :student, :admission_number
  in_place_edit_for :student, :roll_number
  in_place_edit_for :student, :house
  
  def show
    session[:redirect] = request.request_uri
    @student = Student.find(params[:id])
    @school = @student.school
    @klass = @student.klass
    if @school    
      if @klass
        @all_subjects = Subject.find(:all, :order => 'name')
        #@scores = @student.scores.for_exams(@klass.current_exams)
        #@exams = @student.current_exams
      else
        @klasses = @school.klasses
      end
    end
    @user=@student.user
    @user_profile = @user.user_profile
    respond_to do |format|
      format.html # show.html.erb
      format.pdf { render :layout => false }
    end
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
          #          TODO wizard for adding subjects or render breadcrumbs thru ajax
          page.redirect_to session[:redirect]
        end
      else
        render :template => 'students/update_success'
      end
    else
      render :template => 'students/update_failure'
    end
  end
  
  def edit_dob
    @student = Student.find(params[:id])
  end
  
  def update_dob
    @student = Student.find(params[:id])
    @student.attributes = params[:student]
    if @student.save
      render :template => 'students/update_dob_success'
    else
      render :template => 'students/update_dob_failure'
    end
  end
  
  def edit_papers
    @student  = Student.find(params[:id])  
    @klass = @student.klass
  end
  
  def update_papers
    @student = Student.find(params[:id])
    #   remove from all first
    @student.subjects.each do |subject|
      @student.klass.future_activities_for(subject.id).each do |activity|
        activity.event.event_series.users.delete(@student.user)
      end
    end
    @student.paper_ids = params[:paper_ids]
    @student.save
    #     add again
    @student.subjects.each do |subject|
      @student.klass.future_activities_for(subject.id).each do |activity|
        activity.event.event_series.users << @student.user
      end
    end
    @student.save!
  end
  
  def add_to_school
    @student = Student.find(params[:id])
    @school = School.find(params[:entity][:school_id])
    @school.students << @student
    @school.save!
    if session[:redirect].include?('students')
      render :update do |page|
        page.redirect_to student_path(@student)
      end
    else
      render :template => 'students/add_to_school_success'
    end
  end
  
end
