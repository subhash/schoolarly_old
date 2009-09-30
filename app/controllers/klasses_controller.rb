class KlassesController < ApplicationController
  
  before_filter :set_active_tab, :find_school
  layout 'schools'
  
  def index
    @klasses=@school.klasses
  end
  
  def new
    @klass = Klass.new
  end
  
  def create
    @klass = Klass.new(params[:klass])
    if (@school.klasses << @klass)
      redirect_to school_url(@school)
    else
      render :action => :new
    end    
  end
  
  def edit
    @klass = @school.klasses.find(params[:id])
  end
  
  def destroy
    klass = @school.klasses.find(params[:id])
    @school.klasses.delete(klass)
    redirect_to school_url(@school)
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
    @school_id = params[:school_id]
    return(redirect_to(schools_url)) unless @school_id
    @school = School.find(@school_id)
  end
  
  def set_active_tab
    @active_tab = :Classes
  end
  
end
