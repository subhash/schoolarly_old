class KlassesController < ApplicationController
  
  before_filter :set_active_tab
  before_filter :find_school , :only => [:new, :create]
  
  def index
    @klasses=@school.klasses
  end
  
  def new
    @klass = Klass.new
  end
  
  def create
    @klass = Klass.new(params[:klass])
    if (@school.klasses << @klass)
      respond_to do |format|
        format.js {render :template => 'klasses/create_success'}
      end 
    else
      respond_to do |format|          
        format.js {render :template => 'klasses/create_error'}
      end  
    end    
  end
  
  def destroy
    puts "in destroy"
    @klass = Klass.find(params[:id])
    @klass.destroy
    redirect_to school_klasses_path(@klass.school)
  end
  
  def delete
    @klass = Klass.find(params[:id])
    @deleted_klass = @klass
    @klass.destroy
  end
  
  def update
    @klass = @school.klasses.find(params[:id])
    if @klass.update_attributes(params[:klass])
      redirect_to school_url(@school)
    else
      render :action => :edit
    end    
  end
  
  def show
    @klass = Klass.find(params[:id])   
    @school = @klass.school
    add_breadcrumb(@school.name, @school)
    add_breadcrumb(@klass.name)
    add_page_action('Allot Teacher', {:action => '#'})
    add_page_action('Add Exam',{:action => '#'})
    @all_subjects = Subject.find(:all)
    add_js_page_action('Add/Remove Subjects',:partial => 'subjects/add_subjects_form', :locals => {:klass => @klass, :subjects => @all_subjects })    
    #    @school_teachers=@school.teachers
    # 	add_js_page_action('Assign Class Teacher',:partial => 'klasses/klass_teacher', :locals => {:teachers => @school_teachers, :klass_id => @klass.id})
    @students = @klass.current_students      
    @subjects = @klass.subjects
    @teacher_allotments= TeacherAllotment.current_for_klass(@klass.id).group_by{|a| a.subject.id}
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
  
  def set_active_tab
    @active_tab = :Classes
  end
  
  def add_subjects
    @klass = Klass.find(params[:id])
    @klass.subject_ids = params[:klass][:subject_ids]
    @all_subjects = Subject.find(:all)
    @teacher_allotments = TeacherAllotment.current_for_klass(@klass.id).group_by{|a| a.subject.id}
  end
  
  def delete_allotment
    
  end
  
end
