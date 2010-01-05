class TeachersController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  protect_from_forgery :only => [:destroy]
  
  before_filter :set_active_tab_Teachers, :only => [:destroy]
  before_filter :set_active_tab_Allotments, :only => [:allotment_show, :list_add_allotment, :add_allotments, :list_delete_allotment, :delete_allotments]
  before_filter :find_teacher, :except => [:create]
  
  def set_active_tab_Teachers
    @active_tab = :Teachers
  end
  
  def set_active_tab_Allotments
    @active_tab = :Allotments
  end
  
  def find_teacher    
    if(params[:id])
      @teacher = Teacher.find(params[:id])
    end
  end  
  
   
  # POST /students
  # POST /students.xml
  def create
    @teacher = Teacher.new(params[:teacher])
    @school = School.find(params[:school_id])
    @user = User.new(params[:user])
    @teacher.user = @user
    @teacher.school = @school
    @subjects=Hash.new()
    @subjects[@teacher.id]=@teacher.current_subjects 
    begin
      Teacher.transaction do
        @teacher.save!
        @user.invite!
        respond_to do |format|
          flash[:notice] = 'Teacher was successfully created.'
          format.js {render :template => 'teachers/create_success'}
        end 
      end       
    rescue Exception => e
      puts e.inspect
      # handle error
      @teacher = Teacher.new(params[:teacher])
      @teacher.user = @user      
      respond_to do |format|          
        format.js {render :template => 'teachers/create_error'}
      end           
    end
  end
  
    
  # DELETE /teachers/1
  # DELETE /teachers/1.xml
  def destroy
    
    @teacher.user.destroy
    @teacher.destroy
    
    respond_to do |format|
      format.html { redirect_to(teachers_url) }
      format.xml  { head :ok }
    end
  end
  
  def show
    @user=@teacher.user
    set_active_user(@user.id)
    @school=@teacher.school
    
    add_breadcrumb(@school.name, @school)
    add_breadcrumb(  (@teacher.user.user_profile.nil?)? @teacher.user.email : @teacher.user.user_profile.name)
    
    add_page_action('Edit Profile', {:controller => :user_profiles, :action => 'edit', :id => @teacher.user})
    add_page_action('Allot Subjects Classes', {:action => 'allot', :id => @teacher})
    
    @teacher_allotments=(@teacher.current_allotments).group_by{|allotment|allotment.subject_id}
  end
  
  def get_allotment_items(teacher, subjects)
    preSelectedItems=[]
    allotmentItems=[]
    subjects.each do |subject|
      preSelectedItems[subject.id]=teacher.current_klasses.teaches(subject.id)
      allotmentItems[subject.id] = [subject.id,subject.klasses.ofSchool(teacher.school.id).group_by{|klass|klass.level}]
    end
    return preSelectedItems,allotmentItems
  end
  
  def allot
    @school=@teacher.school
    @year = Klass.current_academic_year(@school)
    add_breadcrumb(@school.name, @school)
    add_breadcrumb(@teacher.name, @teacher)
    add_breadcrumb('Allot')
    add_page_action('Edit Profile', {:controller => :user_profiles, :action => 'edit', :id => @teacher.user})
    @subjects=@school.subjects
    @preSelectedItems,@allotmentItems=get_allotment_items(@teacher,@subjects)
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
  
  def close_delete_allotments
    render :update do |page|
      page << "jQuery('#dialog_delete_allotment').dialog('close');"
    end
  end
  
  def list_delete_allotment
    @user=@teacher.user
    @school=@teacher.school
    @year = Klass.current_academic_year(@school)
    @teacher_allotments=(@teacher.current_allotments).group_by{|allotment|allotment.subject_id}
  end
  
  def delete_allotments
    @allotment_ids=params[:allotments]
    allotments=params[:allotments].split(',')
    allotments.each {|allotment_id| 
      if (!allotment_id.empty? && !allotment_id.nil?)
        allotment=TeacherAllotment.find(allotment_id)
        allotment.destroy
      end
    } 
    @teacher_allotments=(@teacher.current_allotments).group_by{|allotment|allotment.subject_id}
  end
  
  def self.tabs(teacher_id)
    user_id=Teacher.find(teacher_id).user.id
    tabs = [:Home => "#",
    :Classes => {:controller => :teachers, :action => 'klasses', :id=>teacher_id},
    :Allotments => {:controller => :teachers, :action => 'allotment_show', :id=>teacher_id},
    :Students => "#",
    :Profile =>  {:controller => :user_profiles, :action => 'show', :id=>user_id}]
    return tabs
  end
  
end
