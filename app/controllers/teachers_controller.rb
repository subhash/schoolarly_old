class TeachersController < ApplicationController
  protect_from_forgery :only => [:destroy]

  before_filter :set_active_tab_Teachers, :only => [:show, :new, :edit, :destroy]
  before_filter :set_active_tab_Allotments, :only => [:allotment_show, :list_add_allotment, :add_allotments, :list_delete_allotment, :delete_allotments]
  before_filter :find_teacher, :except => [ :new, :create]
  
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
   
  # GET /teachers/1
  # GET /teachers/1.xml
  def show
    set_active_user(@teacher.user.id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @teacher }
    end
  end
  
  # GET /teachers/new
  # GET /teachers/new.xml
  def new
    @teacher = Teacher.new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @teacher }
    end
  end
  
  # GET /teachers/1/edit
  def edit

  end
  
  # POST /teachers
  # POST /teachers.xml
  def create
    @teacher = Teacher.new(params[:teacher])
    @user = User.new(params[:user])
    @user.person = @teacher
    respond_to do |format|
      if @teacher.save and @user.invite!
        flash[:notice] = 'Teacher was successfully invited.'
        format.html { redirect_to(@teacher) }
        format.xml  { render :xml => @teacher, :status => :created, :location => @teacher }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @teacher.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /teachers/1
  # PUT /teachers/1.xml
  def update
    
    respond_to do |format|
      if @teacher.update_attributes(params[:teacher])
        flash[:notice] = 'Teacher was successfully updated.'
        format.html { redirect_to(@teacher) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
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
  
  def allotment_show
    @user=@teacher.user
    set_active_user(@user.id)
    @school=@teacher.school
    @year = Klass.current_academic_year(@school)
    @teacher_allotments=(@teacher.current_allotments).group_by{|allotment|allotment.subject_id}
  end
  
  def list_add_allotment
    @school=@teacher.school
    @year = Klass.current_academic_year(@school)
    @allotment_subjects=@school.subjects
  end
  
  def allot_klasses
    @subject=Subject.find(params[:subject_id])
    @subject_id=params[:subject_id]
    current_subject_allotments=@teacher.current_allotments.find_all_by_subject_id(params[:subject_id])
    if current_subject_allotments.empty?
      @allot_subject_klasses=(@teacher.school.klasses).group_by{|klass|klass.level}
    else
      allot_klasses=[]
      current_subject_allotments.each {|allotment|
        allot_klasses << allotment.klass
      }
      @allot_subject_klasses=(@teacher.school.klasses - allot_klasses).group_by{|klass|klass.level}
    end
    render :partial => "allot_klasses", :id=> @subject
  end
  
  def add_allotments
    subject_id=params[:subject_id]
    add_klasses=params[:klasses].split(',')
    add_klasses.each {|klass_id| 
      if (!subject_id.empty? && !klass_id.empty?)
        new_allotment=TeacherAllotment.new(:is_current => 1)
        @subject=Subject.find(subject_id)
        new_allotment.subject=@subject
        new_allotment.klass=Klass.find(klass_id)
        new_allotment.teacher=@teacher
        new_allotment.save!
      end
    } 
    @teacher_allotments=(@teacher.current_allotments).group_by{|allotment|allotment.subject_id}
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
    tabs = [:Home => {:controller => :teachers, :action => 'show', :id=>teacher_id},
    :Classes => {:controller => :teachers, :action => 'klasses', :id=>teacher_id},
    :Allotments => {:controller => :teachers, :action => 'allotment_show', :id=>teacher_id},
    :Students => "#",
    :Profile =>  {:controller => :user_profiles, :action => 'show', :id=>user_id}]
    return tabs
  end
  
end
