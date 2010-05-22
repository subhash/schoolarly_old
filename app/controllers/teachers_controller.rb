class TeachersController < ApplicationController
  
  skip_before_filter :require_user, :only => [:new, :create]
  protect_from_forgery :only => [:destroy]
  
  before_filter :find_teacher, :only => [:show, :edit_papers, :update_papers, :add_to_school]
  
  def set_up
    session[:redirect] = request.request_uri
    @user=@teacher.user
    set_active_user(@user.id)
    if @teacher.school
      @school=@teacher.school
      @users=@school.users
    end
  end
  
  def find_teacher    
    if(params[:id])
      @teacher = Teacher.find(params[:id])
    end
  end  

  def create
    @teacher = Teacher.new(params[:teacher])
    if(params[:school_id])
      @school = School.find(params[:school_id])
      @teacher.school = @school
    end
    @user = User.new(params[:user])
    @user.person = @teacher
    @user.user_profile = UserProfile.new(params[:user_profile])
    if @user.deliver_invitation!
      render :template => 'teachers/create_success'
    else  
      render :template => 'teachers/create_failure'        
    end
  end

  def show
    set_up
    if @teacher.school
      @papers=@teacher.school.unallotted_papers + @teacher.papers
      @teacher_allotments = @teacher.papers.group_by{|p| Subject.find(p.subject_id)}
      @exams = @teacher.exams.select{|e| e.klass.school == @teacher.school} #TODO to fetch only those exams that falls in the current academic year
    end
  end
  
  def add_to_school
    @school = School.find(params[:entity][:school_id])
    @school.teachers << @teacher
    @school.save!
    if session[:redirect].include?('teachers')
      render :update do |page|
        page.redirect_to teacher_path(@teacher)
      end
    else
      render :template => 'teachers/add_to_school_success'
    end
  end
  
  def edit_papers
    @papers=@teacher.school.unallotted_papers + @teacher.papers
  end
  
  def update_papers
    @teacher.paper_ids = params[:paper_ids]
  end
  
  def remove_teacher_allotment
    @paper=Paper.find(params[:id])
    @teacher=@paper.teacher
    @paper.teacher=nil
    @paper.save!
    @papers=@teacher.school.unallotted_papers + @teacher.papers
  end
  
end