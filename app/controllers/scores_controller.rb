class ScoresController < ApplicationController
  
  def grid_data
    @activities = Activity.find(params[:activities])
    @total = @activities.first.students.length
    @students = @activities.first.students
    if(params[:sord] == 'asc')
      @students = @students.sort_by(&params[:sidx].to_sym)
    else
      @students = @students.sort_by(&params[:sidx].to_sym).reverse
    end
    
    @students = @students.paginate  :page => params[:page].to_i, :per_page => params[:rows].to_i  
    @students_scores = @students.each_with_object(ActiveSupport::OrderedHash.new) {|student, hash|
      hash[student] = @activities.collect{|e|e.scores.find_by_student_id(student.id)}
    } 
    respond_to do |format|
      format.xml {render :partial => 'grid_data.xml.builder', :layout => false }
    end   
  end
  
  def row_edit
    @student = Student.find_by_id(params[:id])
    @activities = Activity.find_all_by_id(params[:activities])
    @activities.each do |activity|
      score =  activity.scores.find_by_student_id(@student.id)
      if(score)
        params[activity.id.to_s].blank? ? activity.destroy :  score.score = params[activity.id.to_s].to_i      
      else
        score = Score.new do |s|
          s.score = params[activity.id.to_s].to_i
          s.student = @student
          s.activity = activity
        end unless params[activity.id.to_s].blank?
      end  
      score.save! if score
    end
    respond_to do |format|
      format.js
    end  
  end
  
end
