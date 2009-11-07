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
  
  # GET /scores/1
  # GET /scores/1.xml
  def show
    @score = Score.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @score }
    end
  end
  
  # GET /scores/new
  # GET /scores/new.xml
  def new
    @exam = Exam.find(params[:exam])
    @students = @exam.klass.students
    @existing_scores = {}
    @exam.scores.each {|s| @existing_scores[s.student.id] = s}
    @scores = {}
    @students.each {|student|      
      @scores[student.id] = Score.new
    }
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scores }
    end
  end
  
  # GET /scores/1/edit
  def edit
    @score = Score.find(params[:id])
  end
  
  # POST /scores
  # POST /scores.xml
  def create
    @exam = Exam.find(params[:id])
    @scores = params[:scores]
    flash[:notice] = params.inspect
    Score.transaction do
      @scores.each_pair do |k,v|
        score = Score.new
        score.student = Student.find(k)
        score.exam = @exam
        score.score = v
        score.save!
      end
    end
    redirect_to scores_path
    
    #    respond_to do |format|
    #      if @score.save
    #        flash[:notice] = 'Score was successfully created.'
    #        format.html { redirect_to(@score) }
    #        format.xml  { render :xml => @score, :status => :created, :location => @score }
    #      else
    #        format.html { render :action => "new" }
    #        format.xml  { render :xml => @score.errors, :status => :unprocessable_entity }
    #      end
    #    end
  end
  
  # PUT /scores/1
  # PUT /scores/1.xml
  def update
    @score = Score.find(params[:id])
    
    respond_to do |format|
      if @score.update_attributes(params[:score])
        flash[:notice] = 'Score was successfully updated.'
        format.html { redirect_to(@score) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @score.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /scores/1
  # DELETE /scores/1.xml
  def destroy
    @score = Score.find(params[:id])
    @score.destroy
    
    respond_to do |format|
      format.html { redirect_to(scores_url) }
      format.xml  { head :ok }
    end
  end
end
