class ScoresController < ApplicationController
  # GET /scores
  # GET /scores.xml
  def index
    @scores = Score.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scores }
    end
  end
  
  def show
    @exam = Exam.find(params[:exam])
  end
  
  def grid_data
    @exam = Exam.find(params[:exam])
    @exam_group = @exam.exam_group
    @klass = @exam_group.klass
    @students = @klass.students_studying(@exam.subject.id)
    @students_scores = @students.each_with_object({}) {|student, hash| hash[student] = student.scores.for_exam(@exam.id)}
    respond_to do |format|
      format.xml {render :partial => 'grid_data.xml.builder', :layout => false }
    end   
  end
  
  def row_edit
    @exam = Exam.find(params[:exam])
    @student = Student.find_by_id(params[:id])
    @score = @student.scores.for_exam(@exam.id)
    if(@score)
      @score.score = params[:score]
    else
      @score = Score.new do |s|
        s.score = params[:score]
        s.student = @student
        s.exam = @exam
      end
      @score.save!
    end  
    respond_to do |format|
      format.js
    end  
  end
end
