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
      add_breadcrumb(@school.name, @school)
    end
    if @user == current_user then label = 'Edit Profile'; action = 'edit' else label = 'View Profile'; action = 'show' end
    add_page_action(label, {:controller => :user_profiles, :action => action, :id => @teacher.user})
    @users=get_users_for_composing(@teacher)
    if !@users.nil? # && @user==current_user TODO
      add_js_page_action(:title => 'Compose Message', :render => {:partial => 'conversations/new_form', :locals => {:users => @users.flatten, :mail => Mail.new()}})
    end
  end
  
  def find_teacher    
    if(params[:id])
      @teacher = Teacher.find(params[:id])
    end
  end  
     
  def create
    @teacher = Teacher.new(params[:teacher])
    @user = User.new(params[:user])
    @teacher.user = @user
    if(params[:school_id])
      @school = School.find(params[:school_id])
      @teacher.school = @school
    end
    begin
      Teacher.transaction do
        @teacher.save!
        @user.invite!
        render :template => 'teachers/create_success'
      end       
    rescue Exception => e
      render :template => 'teachers/create_failure.js.rjs'     
    end
  end
    
  def show
    set_up
    add_breadcrumb(@teacher.name)
    if @teacher.school
      @papers=@teacher.school.unallotted_papers + @teacher.papers
      add_js_page_action(:title => 'Add/Remove Papers',:render => {:partial => 'papers/edit_papers_form', :locals => {:entity => @teacher, :papers => @papers}})
      @teacher_allotments = @teacher.papers.group_by{|p| Subject.find(p.subject_id)}
    else
      add_js_page_action(:title => 'Add to school', :render => {:partial =>'schools/add_to_school_form', :locals => {:entity => @teacher, :schools => School.all}})
    end
    @exam_groups = @teacher.exams.collect{|exam| exam.exam_group}.uniq.group_by{|eg| eg.klass}
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
  rescue Exception => e
    render :template => 'teachers/add_to_school_failure'
  end
      
  def edit_papers
    @papers=@teacher.school.unallotted_papers + @teacher.papers
  end
  
  def update_papers
    @teacher.paper_ids = params[:klass][:paper_ids]
    papers=Paper.find(@teacher.paper_ids)
    Paper.transaction do
      @teacher.save!
      papers.each{|p| p.orphan_exams.each{|oe| oe.teacher=@teacher; oe.save!}}      
    end
    if session[:redirect].include?('teachers')
      @teacher_allotments = @teacher.papers.group_by{|paper| paper.subject} 
      @papers = @teacher.school.unallotted_papers + @teacher.papers
      @exam_groups = @teacher.exams.collect{|exam| exam.exam_group}.uniq.group_by{|eg| eg.klass}
      render :template => 'teachers/update_teacher_allotments'
    end
  end
  
  def remove_teacher_allotment
    @paper=Paper.find(params[:id])
    @teacher=@paper.teacher
    @paper.teacher=nil
    @paper.save!
    @papers=@teacher.school.unallotted_papers + @teacher.papers
  end
  
end
