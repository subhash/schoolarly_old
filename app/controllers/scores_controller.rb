class ScoresController < ApplicationController
  
  def grid_data
    @exams = Exam.find(params[:exams])
    @students = @exams.first.students
    @students_scores = @students.each_with_object({}) {|student, hash|
      hash[student] = @exams.collect{|e|e.scores.find_by_student_id(student.id)}
    }
    if(params[:sidx] == 'name')
      @students_scores = (params[:sord] == 'asc')? (@students_scores.sort {|a,b| a[0].name<=>b[0].name}) : (@students_scores.sort {|a,b| a[0].name<=>b[0].name}.reverse)
    elsif(params[:sidx] == 'email')
      @students_scores = (params[:sord] == 'asc')? (@students_scores.sort {|a,b| a[0].email<=>b[0].email}) : (@students_scores.sort {|a,b| a[0].email<=>b[0].email}.reverse)
    end
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
      score.save!
    end
    respond_to do |format|
      format.js
    end  
  end
  
end
