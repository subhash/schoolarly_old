class TeachersController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  protect_from_forgery :only => [:destroy]
   
  before_filter :find_teacher, :only => [:show, :edit, :update_papers, :add_to_school]
  
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
    if !@users.nil? # && @user==current_user
      add_js_page_action(:title => 'Compose Message', :render => {:partial => 'conversations/new_form', :locals => {:users => @users.flatten, :mail => Mail.new()}})
    end
  end
  
  def find_teacher    
    if(params[:id])
      @teacher = Teacher.find(params[:id])
    end
  end  
     
  def new
    @teacher = Teacher.new
    @user = User.new
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
        respond_to do |format|
          flash[:notice] = 'Teacher was successfully created.'
          format.html { redirect_to(edit_password_reset_url(@user.perishable_token)) }
          format.js {render :template => 'teachers/create_success'}
        end 
      end       
    rescue Exception => e
      @teacher = Teacher.new(params[:teacher])
      @teacher.user = @user      
      respond_to do |format|          
        format.html { render :action => 'new' }
        format.js {render :template => 'teachers/create_error'}
      end
    end
  end
    
  def show
    set_up
    add_breadcrumb(@teacher.name)
    if @teacher.school
      @papers=@teacher.school.unallotted_papers + @teacher.papers
      if !@papers.empty?
        add_js_page_action(:title => 'Add/Remove Papers',:render => {:partial => 'papers/edit_papers_form', :locals => {:entity => @teacher, :papers => @papers}})
      end
      @exam_groups = @teacher.exams.collect{|exam| exam.exam_group}.uniq.group_by{|eg| eg.klass}
    else
      add_js_page_action(:title => 'Add to school', :render => {:partial =>'schools/add_to_school_form', :locals => {:entity => @teacher, :schools => School.all}})
    end
  end
  
  def add_to_school
    @school = School.find(params[:entity][:school_id])
    @school.teachers << @teacher
    @school.save!
    if session[:redirect].include?('teacher')
      render :update do |page|
        page.redirect_to teacher_path(@teacher)
      end
    end
  end  
  
  def edit
    @papers=@teacher.school.unallotted_papers + @teacher.papers
    respond_to do |format|
      format.js {render :template => 'teachers/edit'}
    end  
  end
  
  def update_papers
    @teacher.paper_ids = params[:klass][:paper_ids]
    @teacher.save!
    papers=Paper.find(@teacher.paper_ids)
    papers.each{|p| p.orphan_exams.each{|oe| oe.teacher=@teacher; oe.save!}}
    if session[:redirect].include?('school')
      respond_to do |format|
        format.js {render :template => 'schools/update_papers'}
      end 
    else    
      respond_to do |format|
        format.js {render :template => 'teachers/update_papers'}
      end
    end
  end
  
  def remove_paper
    @paper=Paper.find(params[:id])
    @teacher=@paper.teacher
    @paper.teacher=nil
    @paper.save!
    respond_to do |format|
      format.js {render :template => 'teachers/remove_paper'}
    end 
  end
  
end
