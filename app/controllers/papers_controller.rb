class PapersController < ApplicationController
  def create
    @klass = Klass.find(params[:id])
    params[:school_subject_ids] ||= []
    removed_subjects = @klass.school_subject_ids - params[:school_subject_ids].collect{|s|s.to_i}
    @students = []
    removed_subjects.each do |id|
      paper = @klass.papers.find_by_school_subject_id(id)
      @students += paper.students
      paper.students.clear
      paper.destroy
    end
    @klass.school_subject_ids = params[:school_subject_ids]
    # TODO Handle error condition
    @klass.save!
  end
  
  def edit_students
    @paper  = Paper.find(params[:id])  
    @klass = @paper.klass
  end
  
#  TODO add/remove students from future events for the paper
  def add_students
    @paper = Paper.find(params[:id])
    @old_students = Array.new(@paper.students)
    @paper.student_ids = params[:student_ids]
    @paper.save!
    #    student rows to be updated with changes in subjects
    @students = (@old_students | @paper.students) - (@old_students & @paper.students)
  end
  
  def edit_teacher
    @paper = Paper.find(params[:id])
  end
  
#  TODO add/remove teacher user to future events of paper
  def update
    @paper = Paper.find(params[:id])
    @paper.update_attributes(params[:paper])
  end
  
  def destroy
    @paper = Paper.find(params[:id])
    @klass = @paper.klass
    @students = @paper.students.dup
    @paper.students.clear
    @paper.destroy
  end
end
