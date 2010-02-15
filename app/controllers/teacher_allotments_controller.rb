class TeacherAllotmentsController < ApplicationController
  
  def allot_teacher_new
    @subject = Subject.find(params[:subject])
    @klass = Klass.find(params[:klass])
    respond_to do |format|
      format.js {render :template => 'teacher_allotments/allot_teacher_new'}
    end
  end
  
  def allot_teacher
    @teacher_klass_allotment = TeacherKlassAllotment.new(:klass_id => params[:klass_id])
    @klass = Klass.find(params[:klass_id])
    teacher_subject_allotment = TeacherSubjectAllotment.find(:first, :conditions => ["teacher_id = ? and subject_id = ?", params[:teacher_id], params[:subject_id]])
    @teacher_klass_allotment.teacher_subject_allotment = teacher_subject_allotment
    @teacher_klass_allotment.klass = @klass
    @teacher_klass_allotment.start_date = Time.now.to_date
    @all_subjects = Subject.find(:all)
    if (@teacher_klass_allotment.save)
      respond_to do |format|
        format.js {render :template => 'teacher_allotments/allot_teacher_success'}
      end 
    else
      respond_to do |format|          
        format.js {render :template => 'teacher_allotments/allot_teacher_error'}
      end
    end    
  end

  def delete_teacher_allotment    
    @teacher_klass_allotment = TeacherKlassAllotment.find(params[:id])
    @teacher_klass_allotment.end_date = Time.now.to_date
    @teacher_klass_allotment.save!
    @subject=@teacher_klass_allotment.teacher_subject_allotment.subject
    @klass = @teacher_klass_allotment.klass
    @all_subjects = Subject.find(:all)
  end
  
  def edit_klass_allotments
    @teacher_subject_allotment=TeacherSubjectAllotment.find(params[:id])
    @klasses=@teacher_subject_allotment.subject.klasses.ofSchool(@teacher_subject_allotment.teacher.school.id)
     respond_to do |format|
      format.js {render :template => 'teacher_allotments/edit_klass_allotments'}
    end  
  end
    
  def add_klasses
    teacher_subject_allotment=TeacherSubjectAllotment.find(params[:id])
    klass_ids_to_be_added = params[:teacher_subject_allotment][:klass_ids].compact.reject(&:blank?) - teacher_subject_allotment.klass_ids
    klass_ids_to_be_removed = teacher_subject_allotment.klass_ids - params[:teacher_subject_allotment][:klass_ids].compact.reject(&:blank?)
    klass_ids_to_be_added.each do |klass_id|
      teacher_subject_allotment.teacher_klass_allotments << TeacherKlassAllotment.new(:klass_id => klass_id, :start_date => Time.now.to_date)
    end
    klass_ids_to_be_removed.each do |klass_id|
      tka = TeacherKlassAllotment.find(:first, :conditions => {:teacher_subject_allotment_id => teacher_subject_allotment.id, :end_date => nil, :klass_id => klass_id})
      if !tka.nil?
        tka.end_date = tka.updated_at
        tka.save!
      end
    end
    @teacher=teacher_subject_allotment.teacher
  end
    
  def add_subjects
    if params[:entity_klass] == 'Teacher'
      @teacher = Teacher.find(params[:id])
      subjects_to_add = Subject.find(params[:teacher][:subject_ids].compact.reject(&:blank?)) - @teacher.current_subjects
      subjects_to_remove = @teacher.current_subjects - @teacher.allotted_subjects - Subject.find(params[:teacher][:subject_ids].compact.reject(&:blank?))
      subjects_to_add.each do |subject|
        @teacher.teacher_subject_allotments << TeacherSubjectAllotment.new(:school => @teacher.school, :subject => subject)
      end
      TeacherSubjectAllotment.destroy(@teacher.current_subject_allotments.select{|allotment| subjects_to_remove.include?(allotment.subject)}.collect{|alltmnt| alltmnt.id })
      @teacher.reload
    elsif params[:entity_klass] == 'Klass'
      @klass = Klass.find(params[:id])
      @klass.subject_ids = params[:klass][:subject_ids] + @klass.allotted_subjects
      @all_subjects = Subject.find(:all, :order => :name)
      @teacher_subject_allotments = @klass.teacher_klass_allotments.collect{|klass_allotment| klass_allotment.teacher_subject_allotment}.group_by{|s| s.subject.id}
    end
    template_name = params[:entity_klass].underscore.pluralize + '/add_subjects'
    respond_to do |format|
        format.js {render :template => template_name}
      end  
  end
  
end
