class PapersController < ApplicationController
  def create
    @klass = Klass.find(params[:id])
    new_sids = params[:subject_ids] || []
    old_sids = @klass.subject_ids || []
    to_be_deleted = @klass.subject_ids - new_sids
    to_be_added =  new_sids - @klass.subject_ids
    Paper.destroy_all(:klass_id => @klass.id, :subject_id =>  to_be_deleted)
    to_be_added.each do |subject_id|
      @klass.papers << Paper.create(:subject_id => subject_id)
    end
    @klass.save!
  end
  
  def edit_students
    @paper  = Paper.find(params[:id])  
    @klass = @paper.klass
  end
  
  def add_students
    @paper = Paper.find(params[:id])
    @old_students = Array.new(@paper.students)
    @paper.student_ids = params[:paper][:student_ids]
    @paper.save!
    #    student rows to be updated with changes in subjects
    @students = (@old_students | @paper.students) - (@old_students & @paper.students)
  end
  
  def edit_teacher
    @paper = Paper.find(params[:id])
  end
  
  def update
    @paper = Paper.find(params[:id])
    @paper.update_attributes(params[:paper])
  end
  
  def destroy
    @paper = Paper.find(params[:id])
    @deleted_paper = @paper
    @klass = @paper.klass
    @paper.destroy
  end
end
