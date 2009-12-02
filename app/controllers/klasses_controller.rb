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
    add_page_action('Allot Student', {:action => '#'})
    add_page_action('Allot Teacher', {:action => '#'})
    add_page_action('Add Exam',{:action => '#'})
    add_js_page_action('Add Subjects',{:action => '#'})
    add_js_page_action('Assign Class Teacher',{:action => '#'})
    @students = @klass.current_students        
    @klass_subjects = @klass.subjects
    @add_subjects = @school.subjects - @klass.subjects
    @teachers = @klass.teachers
    @subjects=[]
    @teachers.each do |teacher|
      @subjects[teacher.id]=@klass.subjectsTaughtBy(teacher.id)
    end
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
  
  def subjects_edit
    @klass = Klass.find(params[:id])
    @school = @klass.school
    @klass_subjects = @klass.subjects
    @add_subjects = @school.subjects - @klass.subjects   
  end
  
  
  def list_add_subjects
    @klass = Klass.find(params[:id])
    @school = @klass.school
    @klass_subjects = @klass.subjects
    @add_subjects = @school.subjects - @klass.subjects 
  end
  
  def add_subjects
    @klass = Klass.find(params[:id])
    @school = @klass.school
    add_subjects = params[:klass_add_subjects].split(',')
    add_subjects.each {|subject_id| 
      if (!subject_id.empty?)        
        subject = Subject.find(subject_id.split('_').last)
        @klass.subjects << subject
      end
    }  
    @klass_subjects = @klass.subjects
    @add_subjects = @school.subjects - @klass.subjects 
  end
  
  def delete_subject
    @klass = Klass.find(params[:id])
    @school = @klass.school
    subject = @klass.subjects.find(params[:subject_id])
    if(subject)
      @klass.subjects.delete(subject)
      @klass.save
    end
    @klass_subjects = @klass.subjects
    @school_subjects = @school.subjects
    @add_subjects = @school_subjects - @klass_subjects
    render :update do |page|
      page.replace_html("subjects_list", :partial =>'klasses/subjects_list' , :object=>@klass_subjects)
      page.replace_html("add_subjects_list", :partial =>'klasses/subjects', :object=>@add_subjects )     
    end
  end
  
end
