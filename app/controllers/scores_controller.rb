class ScoresController < ApplicationController
  
  def grid_data
    @exam = Exam.find(params[:exam])
    @students = @exam.students
#    sort_by gives errors for @ in email - so sorting cannot be done for emails
#    if(params[:sidx] == 'email')
#      if(params[:sord] == 'asc')
#        @students.sort_by{|s|s.email}
#      else
#        @students.sort_by{|s| -s.email}
#      end
#    elsif(params[:sidx] == 'name')
#      if(params[:sord] == 'asc')
#        @students.sort_by{|s|s.name}
#      else
#        @students.sort_by{|s| -s.name}
#      end  
#    end
    @students_scores = @students.each_with_object({}) {|student, hash| hash[student] = @exam.scores.find_by_student_id(student.id)}
    respond_to do |format|
      format.xml {render :partial => 'grid_data.xml.builder', :layout => false }
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
end
