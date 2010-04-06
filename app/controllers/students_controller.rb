class StudentsController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create]
  
  protect_from_forgery :only => [:create, :update, :destroy] 
  
  
  def self.in_place_loader_for(object, attribute, options = {})
    define_method("get_#{object}_#{attribute}") do
      @item = object.to_s.camelize.constantize.find(params[:id])
      render :text => (@item.send(attribute).blank? ? "[No Name]" : @item.send(attribute))
    end
  end  
  
  in_place_loader_for :student, :admission_number
  in_place_edit_for :student, :admission_number
  
  in_place_loader_for :student, :roll_number
  in_place_edit_for :student, :roll_number
  
  
  # GET /students/1
  # GET /students/1.xml
  def show
    session[:redirect] = request.request_uri
    @student = Student.find(params[:id])
    @school = @student.school
    @klass = @student.klass
    if @school
      add_breadcrumb(@school.name, @school)    
      if @klass
        @all_subjects = Subject.find(:all, :order => 'name')
        add_breadcrumb(@klass.name,@klass)
        add_js_page_action(:title => 'Add/Remove Subjects',:render => {:partial => 'papers/edit_papers_form', :locals => {:entity => @student, :papers => @klass.papers}})
        @exam_groups = @klass.exam_groups.select{|eg| (eg.subjects & @student.subjects).any?}
      else
        @klasses = @school.klasses
        add_js_page_action(:title => 'Assign Class', :render => {:partial => 'students/add_to_klass_form', :locals => {:student => @student}})
      end
    else
      add_js_page_action(:title => 'Add to school', :render => {:partial =>'students/add_to_school_form', :locals => {:student => @student, :schools => School.find(:all)}})
    end
    add_breadcrumb(@student.name)
    add_page_action('Edit Profile', {:controller => :user_profiles, :action => 'edit', :id => @student.user})
    @user=@student.user
    @users=get_users_for_composing(@student)
    if !@users.nil? 
      add_js_page_action(:title => 'Compose Message', :render => {:partial => 'conversations/new_form', :locals => {:users => @users.flatten, :mail => Mail.new()}})
    end
  end
  
  # GET /students/new
  # GET /students/new.xml
  def new
    @student = Student.new
    @user = User.new
  end 
  
  # POST /students
  # POST /students.xml
  def create
    #    TODO - if the user already exists, with school not assigned, 
    #we should let that be added to school after enough warnings
    
    @student = Student.new(params[:student])
    @user = User.new(params[:user])
    @student.user = @user
    if(params[:school_id])
      @school = School.find(params[:school_id])
      @student.school = @school
    end
    begin
      Student.transaction do
        @student.save!
        @user.invite!
        respond_to do |format|
          format.html { redirect_to(edit_password_reset_url(@user.perishable_token)) }
          format.js {
            render_success :object => @student, :insert => {:partial => 'students/student', :object => @student} do |page|
              page << "alert('And I am here')";
            end
          }
        end     
      end      
    rescue Exception => e
      puts e.inspect
      # handle error
      @student = Student.new(params[:student])
      @student.user = @user      
      respond_to do |format|          
        format.html { render :action => "new" }
        format.js {
          render_failure :refresh => {:partial => 'invite_student_form', :locals => {:student => @student, :school => @school}} 
        }
      end           
    end
  end
  
  def edit
    @student = Student.find(params[:id])
    respond_to do |format|          
      format.js {render :template => 'students/edit'}
    end  
  end
  
  def update
    @student = Student.find(params[:id])
    if(@student.update_attributes(params[:student]))    
      #    TODO redesign this when we do wizard flows for right-bar actions
      if(session[:redirect]) and session[:redirect] == student_path(@student)
        render :update do |page|
          page.redirect_to session[:redirect]
        end
      else
        respond_to do |format|
          format.js {render :template => 'students/update_success'}
        end 
      end
    else
      respond_to do |format|          
        format.js {render :template => 'students/update_error'}
      end  
    end
  end
  
  def edit_papers
    @student  = Student.find(params[:id])  
    @klass = @student.klass
    respond_to do |format|          
      format.js {render :template => 'students/edit_papers'}
    end  
  end
  
  def update_papers
    @student = Student.find(params[:id])
    @student.paper_ids = params[:klass][:paper_ids]
    @student.save!
  end
  
  def add_to_school
    @student = Student.find(params[:id])
    @school = School.find(params[:student][:school_id])
    @school.students << @student
    @school.save!
    render :update do |page|
      page.redirect_to student_path(@student)
    end
  end
  
  def remove
    @student = Student.find(params[:id])
    @klass = @student.klass
    @school = @student.school
    @student.papers.delete_all
    @student.klass = nil
    @student.save!
    if session[:redirect].include?('school')
      @student.school = nil
      @student.save!
      respond_to do |format|
        format.js {render :template => 'schools/remove_student'}
      end 
    else    
      respond_to do |format|
        format.js {render :template => 'klasses/remove_student'}
      end 
    end
  end
end
