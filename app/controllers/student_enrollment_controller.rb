class StudentEnrollmentController < ApplicationController
  

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
    @student = Student.find(params[:id])
    @school = @student.school
    set_active_user(@student.user.id)
    @active_tab = :Class
    @year = Klass.current_academic_year(@school)
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
    @action = 'subjects_list'
    @student_enrollment = StudentEnrollment.new
    @student_enrollment.student = @student
    @student_enrollment.admission_number = @student.admission_number
  end
  
  def create
    @student_enrollment = StudentEnrollment.new(params[:student_enrollment])
    @student = Student.find(params[:id])
    @klass = Klass.find(params[:klass_id])    
    @student_enrollment.klass = @klass
    #@student_enrollment.admission_number = @student.admission_number
    @student_enrollment.start_date = Time.now.to_date
    subjects = params[:subject_subscriptions].split(',')
    subjects.each {|subject_id| 
      if (!subject_id.empty?)        
        subject = Subject.find(subject_id.split('_').last)
        @student_enrollment.subjects << subject
      end
    }
    @student.enrollments << @student_enrollment
    @student.current_enrollment = @student_enrollment
    if(@student.save)
      flash[:notice] = @student.user.email + " enrolled to "+@klass.name
      redirect_to session[:redirect]
    else
      render :action => :new
    end
  end
  
  def subjects_list
    @klass = Klass.find(params[:id])
    @school = @klass.school
    @subjects = @klass.subjects
  end
  
  def edit
    @student_enrollment  = StudentEnrollment.find(params[:id])
    @student = @student_enrollment.student
    @school = @student_enrollment.student.school
    @klass = @student_enrollment.klass
    @year = Klass.current_academic_year(@school)
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
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
    @active_tab = "Class:Subjects"
  end
  
end
