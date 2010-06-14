class ScoresController < ApplicationController
  
  def grid_data
    @exam = Exam.find(params[:exam])
    @students = @exam.students
    @students_scores = @students.each_with_object({}) {|student, hash| hash[student] = @exam.scores.find_by_student_id(student.id)}
    if(params[:sidx] == 'score')
      @students_scores = (params[:sord] == 'asc')? (@students_scores.sort {|a,b| a[1].score<=>b[1].score}) : (@students_scores.sort {|a,b| a[1].score<=>b[1].score}.reverse)
    elsif(params[:sidx] == 'name')
      @students_scores = (params[:sord] == 'asc')? (@students_scores.sort {|a,b| a[0].name<=>b[0].name}) : (@students_scores.sort {|a,b| a[0].name<=>b[0].name}.reverse)
    elsif(params[:sidx] == 'email')
      @students_scores = (params[:sord] == 'asc')? (@students_scores.sort {|a,b| a[0].email<=>b[0].email}) : (@students_scores.sort {|a,b| a[0].email<=>b[0].email}.reverse)
    end
    respond_to do |format|
      format.xml {render :partial => 'grid_data.xml.builder', :layout => false }
    end   
  end
  
  def grid_data_multiple
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
      format.xml {render :partial => 'grid_data_multiple.xml.builder', :layout => false }
    end   
  end
  
  
  def row_edit
    @exam = Exam.find(params[:exam])
    @student = Student.find_by_id(params[:id])
    @score =  @exam.scores.find_by_student_id(@student.id)
    if(@score)
      @score.score = params[:score]
    else
      @score = Score.new do |s|
        s.score = params[:score]
        s.student = @student
        s.exam = @exam
      end
    end  
    @score.save!
    respond_to do |format|
      format.js
    end  
  end
  
  def row_edit_multiple
    @student = Student.find_by_id(params[:id])
    @exams = Exam.find_all_by_id(params[:exams])
    @exams.each do |exam|
      score =  exam.scores.find_by_student_id(@student.id)
      if(score)
        score.score = params[exam.id.to_s].to_i
      else
        score = Score.new do |s|
          s.score = params[exam.id]
          s.student = @student
          s.exam = exam
        end
      end  
      score.save!
    end
    respond_to do |format|
      format.js
    end  
  end
  
end
