class StudentEnrollmentsController < ApplicationController
  
  
  def self.in_place_loader_for(object, attribute, options = {})
    define_method("get_#{object}_#{attribute}") do
      @item = object.to_s.camelize.constantize.find(params[:id])
      render :text => (@item.send(attribute).blank? ? "[No Name]" : @item.send(attribute))
    end
  end  
  
  before_filter :set_active_tab
  
  in_place_loader_for :student, :admission_number
  in_place_edit_for :student, :admission_number
  
  in_place_loader_for :student_enrollment, :roll_number
  in_place_edit_for :student_enrollment, :roll_number
  
  def new
    @student = Student.find(params[:student_id])
    @school = @student.school
    @year = Klass.current_academic_year(@school)
    @klasses = @school.klasses.in_year(@year)
    @student_enrollment = StudentEnrollment.new
    @student_enrollment.student = @student
    @student_enrollment.admission_number = @student.admission_number
    respond_to do |format|          
      format.js {render :template => 'student_enrollments/new'}
    end  
  end
  
  def create
    @student_enrollment = StudentEnrollment.new(params[:student_enrollment])
    @student = Student.find(params[:student_id])
    @student_enrollment.start_date = Time.now.to_date    
    @student.enrollments << @student_enrollment
    @student.current_enrollment = @student_enrollment
    if(@student.save)    
      respond_to do |format|
        format.js {render :template => 'student_enrollments/create_success'}
      end 
    else
      @school = @student.school
      @year = Klass.current_academic_year(@school)
      @klasses = @school.klasses.in_year(@year)
      respond_to do |format|          
        format.js {render :template => 'student_enrollments/create_error'}
      end  
    end
  end
  
  def edit
    @student_enrollment  = StudentEnrollment.find(params[:id])
    @student = @student_enrollment.student   
    @klass = @student_enrollment.klass
    respond_to do |format|          
      format.js {render :template => 'student_enrollments/edit'}
    end  
  end
  
  def add_subjects
    @student_enrollment = StudentEnrollment.find(params[:id])
    @student = @student_enrollment.student
    @student_enrollment.subject_ids = params[:student_enrollment][:subject_ids]
  end
  
  def update
    @student_enrollment = StudentEnrollment.find(params[:id])
    @student = @student_enrollment.student
    @student_enrollment.end_date = Time.now.to_date
    @new_enrollment  = StudentEnrollment.new(params[:student_enrollment])
    @klass = Klass.find(params[:klass_id])    
    @new_enrollment.klass = @klass
    #@student_enrollment.admission_number = @student.admission_number
    @new_enrollment.start_date = Time.now.to_date
    subjects = params[:subject_subscriptions].split(',')
    subjects.each {|subject_id| 
      if (!subject_id.empty?)        
        subject = Subject.find(subject_id.split('_').last)
        @new_enrollment.subjects << subject
      end
    }
    @student.enrollments << @new_enrollment
    @student.current_enrollment = @new_enrollment
    if(@student.save)
      flash[:notice] = @student.user.email + " enrolled to "+@klass.name
      redirect_to session[:redirect]
    else
      render :action => :edit
    end
  end
  
  def set_active_tab
    @active_tab = "Class/Subjects"
  end
  
end
