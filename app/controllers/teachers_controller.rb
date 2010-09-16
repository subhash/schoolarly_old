class TeachersController < ApplicationController
  
  skip_before_filter :require_user, :only => [:new, :create]
  protect_from_forgery :only => [:destroy]
  
  in_place_edit_for :teacher, :qualifications
  
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
    session[:redirect] = request.request_uri
    @teacher = Teacher.find(params[:id])
    @user=@teacher.user
    @user_profile = @user.user_profile
    @papers= @teacher.papers
    @owned_klasses = @teacher.owned_klasses.group_by{|klass|klass.level_id}
    if @teacher.school
      @school=@teacher.school
      @users=@school.users
    end
end

def add_to_school
  @teacher = Teacher.find(params[:id])
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
  @teacher = Teacher.find(params[:id])
  @papers=@teacher.school.unallotted_papers + @teacher.papers
end

def update_papers
  @teacher = Teacher.find(params[:id])
  @teacher.paper_ids = params[:paper_ids]
  @teacher.save!
end

def remove_teacher_allotment
  @paper=Paper.find(params[:id])
  @teacher=@paper.teacher
  @paper.teacher=nil
  @paper.save!
  @papers=@teacher.school.unallotted_papers + @teacher.papers
end

end