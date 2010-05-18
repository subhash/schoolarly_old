class KlassesController < ApplicationController
  
  before_filter :find_school , :only => [:new, :create]
  
  def index
    @klasses=Klass.all :order => "school_id, level, division"
  end
  
  def create
    @klass = Klass.new(params[:klass])
    if (@school.klasses << @klass)
      render :template => 'klasses/create_success'
    else
      render :template => 'klasses/create_error'  
    end    
  end
  
  def destroy    
    @klass= Klass.find(params[:id])
    @klass_exams = @klass.school.klasses.each_with_object({}) do |klass, hash|
      hash[klass.id] = klass.exams.group_by{|e| e.exam_group}
    end
    puts "destroying class"
    if(current_user.person.is_a?(SchoolarlyAdmin))
    puts 'schoolarly admin'
      @klass.papers.destroy_all
      @klass.exam_groups.destroy_all
      @klass.destroy
      redirect_to :action => 'index'
    else
      puts "destroyed"
      @deleted_klass = @klass
      @klass.destroy
    end
  end
  
  def show
    @klass = Klass.find(params[:id])
    @school = @klass.school
    @subjects=@klass.subjects
    @exams = @klass.exams
    @klass_user_ids=@klass.users.collect{|u| u.id}
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
