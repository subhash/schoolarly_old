class ScoresController < ApplicationController
  
  def grid_data
    @exams = Exam.find(params[:exams])
    @total = @exams.first.students.length
    @students = @exams.first.students
    if(params[:sord] == 'asc')
      @students = @students.sort_by(&params[:sidx].to_sym)
    else
      @students = @students.sort_by(&params[:sidx].to_sym).reverse
    end
    
    @students = @students.paginate  :page => params[:page].to_i, :per_page => params[:rows].to_i  
    @students_scores = @students.each_with_object(ActiveSupport::OrderedHash.new) {|student, hash|
      hash[student] = @exams.collect{|e|e.scores.find_by_student_id(student.id)}
    } 
    respond_to do |format|
      format.xml {render :partial => 'grid_data.xml.builder', :layout => false }
    end   
  end
  
  def row_edit
    @student = Student.find_by_id(params[:id])
    @exams = Exam.find_all_by_id(params[:exams])
    @exams.each do |exam|
      score =  exam.scores.find_by_student_id(@student.id)
      if(score)
        params[exam.id.to_s].blank? ? score.destroy :  score.score = params[exam.id.to_s].to_i      
      else
        score = Score.new do |s|
          s.score = params[exam.id.to_s].to_i
          s.student = @student
          s.exam = exam
        end unless params[exam.id.to_s].blank?
      end  
      score.save! if score
    end
    respond_to do |format|
      format.js
    end  
  end
  
end
