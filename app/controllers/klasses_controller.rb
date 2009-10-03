class KlassesController < ApplicationController
  
  before_filter :set_active_tab
  before_filter :find_school , :only => [:new, :create]
  
  def index
    @klasses=@school.klasses
  end
  
  def new
    @klass = Klass.new
  end
  
  def create
    @klass = Klass.new(params[:klass])
    if (@school.klasses << @klass)
      redirect_to school_klasses_path(@school)
    else
      render :action => :new
    end    
  end
  
  def destroy
    puts "in destroy"
    @klass = Klass.find(params[:id])
    @klass.destroy
    redirect_to school_klasses_path(@klass.school)
  end
  
  def update
    @klass = @school.klasses.find(params[:id])
    if @klass.update_attributes(params[:klass])
      redirect_to school_url(@school)
    else
      render :action => :edit
    end    
  end
  
  def show
    @klass = Klass.find(params[:id])    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @klass }
    end
  end  
  
  def find_school    
    if(params[:school_id])
      @school = School.find(params[:school_id])
    end
  end   
  
  def set_active_tab
    @active_tab = :Classes
  end
    
end
