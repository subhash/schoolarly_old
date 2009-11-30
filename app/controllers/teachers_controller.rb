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
  
  # POST /teachers
  # POST /teachers.xml
  def create
    @teacher = Teacher.new(params[:teacher])
    @user = User.new(params[:user])
    @teacher.user = @user
    begin
      Teacher.transaction do
        @teacher.save!
        @user.invite!
        respond_to do |format|
          flash[:notice] = 'Teacher was successfully created.'
          format.html { render :text => flash[:notice] } if request.xhr?
          format.html { redirect_to(edit_password_reset_url(@user.perishable_token)) }
          format.xml  { render :xml => @teacher, :status => :created, :location => @teacher }                  
        end        
      end      
    rescue Exception => e
      puts e.inspect
      # handle error
      @teacher = Teacher.new(params[:teacher])
      @teacher.user = @user
      respond_to do |format|
        format.html { render :partial => 'invite_teacher_form', :locals => {:teacher => @teacher}, :status => 403} if request.xhr?
        format.html { render :action => "new" }
        format.xml  { render :xml => @teacher.errors, :status => :unprocessable_entity }      
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
  
  def get_school_subjects(school_id)
    school_subjects=[]
    Klass.current_klasses(school_id, Klass.current_academic_year(school_id)).each do |klass|
      school_subjects = school_subjects | klass.subjects
    end
    return school_subjects
  end
  
  def get_allotment_items(teacher, subjects)
    preSelectedItems=[]
    allotmentItems=[]
    subjects.each do |subject|
      allotted_klasses=[]
      teacher.current_allotments.find_all_by_subject_id(subject.id).each do |allotment|
        allotted_klasses << allotment.klass.id
      end
      preSelectedItems[subject.id]=allotted_klasses
      klasses = (subject.current_subject_klasses(teacher.school.id)).group_by{|klass|klass.level}
      allotmentItems[subject.id] = [subject.id,klasses]
    end
    return preSelectedItems,allotmentItems
  end
  
  def allot
    @school=@teacher.school
    @year = Klass.current_academic_year(@school)
    add_breadcrumb(@school.name, @school)
    add_breadcrumb((@teacher.user.user_profile.nil?)? @teacher.user.email : @teacher.user.user_profile.name, @teacher)
    add_breadcrumb('Allot')
    add_page_action('Edit Profile', {:controller => :user_profiles, :action => 'edit', :id => @teacher.user})
    @subjects=get_school_subjects(@school.id)
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
