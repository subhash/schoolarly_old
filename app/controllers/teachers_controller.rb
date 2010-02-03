class TeachersController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  protect_from_forgery :only => [:destroy]
   
  before_filter :find_teacher, :except => [:create]
  
  def set_up
    @user=@teacher.user
    set_active_user(@user.id)
    if @teacher.school
      @school=@teacher.school
      add_breadcrumb(@school.name, @school)
    end
    if @user == current_user then label = 'Edit Profile'; action = 'edit' else label = 'View Profile'; action = 'show' end
    add_page_action(label, {:controller => :user_profiles, :action => action, :id => @teacher.user})
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
      @active_cntrlr = 'schools'
    else
      @active_cntrlr = 'users'
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
      add_js_page_action(:title => 'Add/Remove Subjects', :render => {:partial => 'subjects/add_subjects_form', :locals => {:entity => @teacher, :subjects => Subject.all, :disabled => @teacher.allotted_subject_ids }})
    end
    @exams=@teacher.exams.group_by{|e| e.exam_group}
  end
  
  def add_subjects
    @teacher = Teacher.find(params[:id])
    subjects_to_add = Subject.find(params[:teacher][:subject_ids].compact.reject(&:blank?)) - @teacher.current_subjects
    subjects_to_remove = @teacher.current_subjects - @teacher.subjects - Subject.find(params[:teacher][:subject_ids].compact.reject(&:blank?))
    subjects_to_add.each do |subject|
      @teacher.teacher_subject_allotments << TeacherSubjectAllotment.new(:school => @teacher.school, :subject => subject)
    end
    TeacherSubjectAllotment.destroy(@teacher.current_subject_allotments.select{|allotment| subjects_to_remove.include?(allotment.subject)}.collect{|alltmnt| alltmnt.id })
    @teacher.reload
  end
  
end
