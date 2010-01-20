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

    add_page_action('Allot Subjects/Classes', {:action => 'allot', :id => @teacher}) if @school
    @allotments=(@teacher.current_allotments).group_by{|allotment|allotment.subject_id}
    @exams=@teacher.exams.group_by{|e| e.exam_group}
  end
  
  def get_allotment_items(teacher, subjects)
    preSelectedItems= subjects.each_with_object({}) do |subject, hash|
      hash[subject.id] = teacher.current_klasses.teaches(subject.id)
    end
    allotmentItems=subjects.each_with_object({}) do |subject, hash|
      hash[subject.id] = [subject.id,subject.klasses.ofSchool(teacher.school.id).group_by{|klass|klass.level}]
    end
    return preSelectedItems,allotmentItems
  end
  
  def allot
    set_up
    if !@school
      redirect_to(url_for( :controller => :teachers, :action => 'show', :id=>@teacher))
    else
      @year = Klass.current_academic_year(@school)
      add_breadcrumb(@teacher.name, @teacher)
      add_breadcrumb('Allot')
      @subjects=@school.subjects
      @preSelectedItems,@allotmentItems=get_allotment_items(@teacher,@subjects)
    end
  end
  
  def add_allotments
    subject_id=params[:subject_id]
    add_klasses=params[:klasses].split(',')
    add_klasses.each  do |klass_id| 
      if (!subject_id.empty? && !klass_id.empty?)
        new_allotment=TeacherAllotment.new(:is_current => 1)
        @subject=Subject.find(subject_id)
        new_allotment.subject=@subject
        new_allotment.klass=Klass.find(klass_id)
        new_allotment.teacher=@teacher
        new_allotment.save!
      end
    end
    flash[:notice] = 'Allotment was successfully done.'
    redirect_to(url_for( :controller => :teachers, :action => 'show', :id=>@teacher))
  rescue Exception => e
    flash[:notice]="Error occured in allotment: <br /> #{e.message}"
    redirect_to(url_for( :controller => :teachers, :action => 'show', :id=>@teacher)) 
  end
  
end
