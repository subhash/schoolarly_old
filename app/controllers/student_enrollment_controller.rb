class StudentEnrollmentController < ApplicationController
  
  before_filter :set_active_tab
  
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
    @student_enrollment.admission_number = @student.admission_number
    @student_enrollment.enrollment_date = Time.now.to_date
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
      redirect_to :action => :new
    end
  end
  
  def subjects_list
    @klass = Klass.find(params[:id])
    @school = @klass.school
    @subjects = @klass.subjects
  end
  
  def set_active_tab
    @active_tab = :CurrentClass
  end
  
end
