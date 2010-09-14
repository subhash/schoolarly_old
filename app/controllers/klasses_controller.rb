class KlassesController < ApplicationController
  
#  before_filter :find_school , :only => [:new, :create]
  
  def index
    @klasses=Klass.all :order => "school_id, level_id, division"
  end
  
  def new
    @klass = Klass.new(:school_id => params[:school_id])
    render :update do |page|
      page.open_dialog "Add Class", :partial => 'klasses/new_klass_form', :locals => {:klass => @klass, :levels => Level.all(:order => ["cast(name as decimal)"])}
    end
  end
  
  def create
    @klass = Klass.new(params[:klass])
    if (@klass.save)
      render :template => 'klasses/create_success'
    else
      render :template => 'klasses/create_error'  
    end    
  end
  
  def destroy    
    @klass= Klass.find(params[:id])
    if(current_user.person.is_a?(SchoolarlyAdmin))
      @klass.papers.destroy_all
      @klass.destroy
    else
      @klass.destroy
    end
  end
  
  def show
    @klass = Klass.find(params[:id])
    @school = @klass.school
    @assessments = @klass.assessments
    @klass_user_ids = @klass.users.collect{|u| u.id}
    session[:redirect] = request.request_uri
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @klass }
    end
  end  
  
  def find_school    
    if(params[:school_id])
      @school = School.find(params[:school_id])
    end
  end   
  
  def add_students
    @klass = Klass.find(params[:id])  
    @new_students = Student.find(params[:student_ids])
    @new_students.each do |student|
      student.klass = @klass
      student.save!      
    end
    @klass.save!
  end
  
  def remove_student
    @student = Student.find(params[:id])
    @klass = @student.klass
    @student.papers.delete_all
    @student.klass = nil
    @student.save!
  end
  
  def add_subjects
    @klass = Klass.find(params[:id]) 
    render :update do |page|
      page.open_dialog("Add Subjects to #{@klass.name}", :partial => 'papers/create_papers_form', :locals => {:klass => @klass, :school_subjects => @klass.school.school_subjects})
    end
  end
  
  def edit
    @klass = Klass.find(params[:id])
  end
  
  def update
    @klass = Klass.find(params[:id])
    @old_teacher = @klass.class_teacher
    @teacher = Teacher.find(params[:klass][:teacher_id])
    @klass.class_teacher = @teacher
    @klass.save!
  end
  
end
