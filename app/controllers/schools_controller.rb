class SchoolsController < ApplicationController
  
  #skip_before_filter :require_user, :only => :index
  #permit "creator of Student", :except => :index
  protect_from_forgery :only => [:create, :update, :destroy]
  
  # GET /schools
  # GET /schools.xml
  def index
    @active_tab = :Home
    @schools = School.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schools }
    end
  end
  
  # GET /schools/1
  # GET /schools/1.xml
  def show
    @active_tab = :Home
    @school=School.find(params[:id])
    set_active_user(@school.user.id)
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @school }
    end
  end
  
  # GET /schools/new
  # GET /schools/new.xml
  def new
    @school = School.new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @school }
    end
  end
  
  # GET /schools/1/edit
  def edit
    @school = School.find(params[:id])
    @user = @school.user
    @user_profile=@user.user_profile
  end
  
  # POST /schools
  # POST /schools.xml
  def create
    @school = School.new(params[:school])
    @user = User.new(params[:user])
    @user.person = @school
    respond_to do |format|
      if @school.save and @user.invite!
        flash[:notice] = 'School was successfully created.'
        format.html { redirect_to(@school) }
        format.xml  { render :xml => @school, :status => :created, :location => @school }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /schools/1
  # PUT /schools/1.xml
  def update
    #@active_tab = :Profile
    @school = School.find(params[:id])
    
    respond_to do |format|
      if @school.update_attributes(params[:school]) 
        flash[:notice] = 'School was successfully updated.'
        format.html { redirect_to(@school) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @school.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /schools/1
  # DELETE /schools/1.xml
  def destroy
    @school = School.find(params[:id])
    @school.user.destroy
    @school.destroy
    
    respond_to do |format|
      format.html { redirect_to(schools_url) }
      format.xml  { head :ok }
    end
  end
  
  def teachers_index
    @active_tab = :Teachers
    @school=School.find(params[:id])
    set_active_user(@school.user.id)
    @teachers=@school.teachers
    if @teachers.empty?
      flash[:notice] = 'No teacher exists.'
    end
    @year = Klass.current_academic_year(@school)
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
  end
  
  #  def add_school_teacher
  #    @school=School.find(params[:id])
  #    @user = User.find(:first, :conditions => ["email = ?",params[:user][:email]])
  #    if @user.nil?
  #      flash[:notice] = "The user does not exist"
  #    else
  #      @school.teachers << @user.person
  #    end
  #  end
  
  def new_teacher
    @active_tab = :Teachers
    @user = User.new
    @school = School.find(params[:id])
    render :update do |page|      
      page.replace_html ("new_teacher_form", :partial => "schools/new_teacher")
      page[:new_teacher_form].show
    end        
  end
  
  def create_teacher
    @school = School.find(params[:school_id])
    @user = User.new(params[:user])
    if(@user.save)
      @teacher = Teacher.new
      @teacher.user = @user
      @user.person = @teacher
      @teacher.school = @school
      if @teacher.save
        @teachers = @school.teachers
        flash[:notice] = "Account registered!"        
        render :update do |page|
          page.select("form").first.reset
          page[:new_teacher_form].hide
          page.insert_html :bottom, 'teachers', :partial => "teacher_user", :object => @user
        end
      else
        render :action => :new
      end
    else
      render :action => :new
    end  
  end
  
  def add_teacher    
    @school = School.find(params[:school_id])
    if(params[:email])
      @user = User.find_by_email_and_person_type(params[:email], 'Teacher')
      if @user.nil?
        render :update do |page|
          page[:password].show
          page[:add_teacher_button].disable
        end
      else
        @teacher = @user.person
        @teacher.school = @school
        if @teacher.save
          @teachers = @school.teachers
          flash[:notice] = "Account registered!"
          render :update do |page|
            page.select("form").first.reset
            page[:new_teacher_form].hide
            page.insert_html :bottom, 'teachers', :partial => "teacher_user", :object => @user
          end
        end
      end
    end
  end 
  
  def auto_complete_for_user_email(email, person_type)
    find_options = { 
      :conditions => [ "LOWER(#{:email}) LIKE ? AND person_type = ?", email.downcase + '%' , person_type], 
      :order => "#{:email} ASC",
      :limit => 10 }    
    @items = User.find(:all, find_options)   
    render :inline => "<%= auto_complete_result @items, '#{:email}' %>"
  end
  
  def auto_complete_for_student_email
    auto_complete_for_user_email(params[:user][:email],'Student')
  end
  
  def auto_complete_for_teacher_email
    auto_complete_for_user_email(params[:user][:email],'Teacher')
  end
  
  def students_list
    @active_tab = :Students
    @school = School.find(params[:id])
    set_active_user(@school.user.id)
    @students = @school.students
    @year = Klass.current_academic_year(@school)
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}   
  end
  
  
  def new_student
    @active_tab = :Students
    @user = User.new
    @school = School.find(params[:id])
    render :update do |page|      
      page.replace_html ("new_student_form", :partial => "schools/new_student")
      page[:new_student_form].show
    end        
  end
  
  def create_student
    @school = School.find(params[:school_id])
    @user = User.new(params[:user])
    if(@user.save)
      puts "user save"
      @student = Student.new
      @student.user = @user
      @user.person = @student
      @student.school = @school
      if @student.save
        @students = @school.students
        flash[:notice] = "Account registered!"        
        render :update do |page|
          page.select("form").first.reset
          page[:new_student_form].hide
          page.replace_html("school_students_table", :partial => "students")
        end
      else
        render :action => :new
      end
    else
      puts "user save else"
      render :action => :new
    end  
  end
  
  def add_student    
    @school = School.find(params[:school_id])
    if(params[:email])
      @user = User.find_by_email_and_person_type(params[:email], 'Student')
      if @user.nil?
        render :update do |page|
          page[:password].show
          page[:add_student_button].disable
        end
      else
        @student = @user.person
        @student.school = @school
        @student.admission_number = params[:admission_number]
        if @student.save
          @students = @school.students
          flash[:notice] = "Account registered!"
          render :update do |page|
            page.select("form").first.reset
            page[:new_student_form].hide
            page.replace_html("school_students_table", :partial => "students")
          end
        end
      end
    end
  end 
  
  
  def remove_student
    @school = School.find(params[:id])
    @student = Student.find(params[:student_id])
    @school.students.delete(@student)
    if @school.save
      @students = @school.students
      render :update do |page|
        page.replace_html("school_students_table", :partial => "students")
      end
    end
  end
  
  def klasses
    @active_tab = :Classes
    @school=School.find(params[:id])
    set_active_user(@school.user.id)
    @year = Klass.current_academic_year(@school)
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
    @school_subjects = @school.subjects
    @add_subjects = Subject.find(:all) -  @school_subjects
    @action = 'subjects_edit'
  end
  
  def list_delete_klasses   
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
  end
  
  def delete_klasses
    delete_klasses = params[:delete_klasses].split(',')
    delete_klasses.each {|klass_id| 
      if (!klass_id.empty?) 
        Klass.destroy(klass_id.split('_').first)
      end
    }  
    @school=School.find(params[:id])
    @year = Klass.current_academic_year(@school)
    @klasses = (Klass.current_klasses(@school, @year)).group_by{|klass|klass.level}
  end
  
  def delete_subject
    @school = School.find(params[:id])
    subject = @school.subjects.find(params[:subject_id])
    if(subject)
      @school.subjects.delete(subject)
      @school.save
    end
    @all_subjects = Subject.find(:all)
    @school_subjects = @school.subjects
    @add_subjects = @all_subjects - @school.subjects
    render :update do |page|
      page.replace_html("school_subjects_list", :partial =>'schools/subjects_list' , :object=>@school_subjects)
      page.replace_html("school_add_subjects_list", :partial =>'schools/subjects', :object=>@add_subjects )
    end
  end
  
  def list_add_subjects
    @school = School.find(params[:id])
    @all_subjects = Subject.find(:all)
    puts "in list add - schools - "+@all_subjects.inspect
    @add_subjects = @all_subjects - @school.subjects
  end
  
  def add_subjects
    @school = School.find(params[:id])
    add_subjects = params[:school_add_subjects].split(',')
    add_subjects.each {|subject_id| 
      if (!subject_id.empty?)
        subject = Subject.find(subject_id.split('_').last)
        @school.subjects << subject
      end
    }  
    @school_subjects = @school.subjects
    @add_subjects = Subject.find(:all) - @school_subjects
  end
  
  def exam_groups_index
    @active_tab = :Exams
    @school=School.find(params[:id])
    @year = Klass.current_academic_year(@school)
    @klasses=Klass.current_klasses(@school, @year)
    if params[:exam_group]
      @exam_group=ExamGroup.find(params[:exam_group])
      @exams=@exam_group.exams
    end
    exam_groups=[]
    for @klass in @klasses
      if @klass.exam_groups.empty? || @klass.exam_groups.nil?
        exam_groups << ExamGroup.new(:klass => @klass)
      end
      @klass.exam_groups.each do |eg|
        exam_groups << eg  
      end
    end
    @exam_groups = exam_groups.group_by{|eg| Klass.find(eg.klass_id)}
  end
  
  def exam_index
    @active_tab = :Exams
    @exam_group=ExamGroup.find(params[:id])
    @exams=@exam_group.exams
    #subjects=@examgroup.klass.subjects
    @subjects=Subject.find(:all)
    render :partial => "exam_index", :id=> @exams   
  end
  
  def remove_exam_group
    @active_tab = :Exams
    @exam_group=ExamGroup.find(params[:id])
    klass=@exam_group.klass
    div_name=klass.id.to_s + '_content_table'
    Exam.delete(@exam_group.exams)
    @exam_group.save!
    @exam_group.destroy
    if klass.exam_groups.empty?
      render :update do |page|      
        page.replace_html(div_name, :text => "<blockquote>No exam group added yet</blockquote>")
        page.replace_html("exams", :text => "")
      end
    else
      render :update do |page|      
        page.replace_html(div_name, :partial => 'exam_group', :collection => klass.exam_groups)
        page.replace_html("exams", :text => "")
      end
    end
    
  end
  
  def add_exam_group_dialog_show
    @klass=Klass.find(params[:id])
    @exam_types=ExamType.find(:all)
  end
  
  def add_exam_group
    @klass=Klass.find(params[:id])
    exam_group=ExamGroup.new()
    exam_group.exam_type=ExamType.find(params[:exam_type])
    exam_group.description=params[:description]
    @klass.exam_groups << exam_group
    @klass.save!
    div_name=@klass.id.to_s + '_content_table'
    if @klass.exam_groups.count==1
      render :update do |page|
        page << "jQuery('#dialog_add_exam_group').dialog('close');"
        page.replace_html(div_name, :partial =>'exam_group', :object => exam_group)
      end
    else
      render :update do |page|
        page << "jQuery('#dialog_add_exam_group').dialog('close');"
        page.insert_html(:bottom, div_name, :partial =>'exam_group', :object => exam_group)
      end
    end    
  rescue Exception => e
    flash[:notice]="Error occured in exam group add: <br /> #{e.message}"
  end
  
  def exam_group_edit
    @exam_group=ExamGroup.find(params[:id])
    #subjects=@examgroup.klass.subjects
    subjects=Subject.find(:all)
    @subjects = subjects.map do |subject|
      [subject.name,subject.id]
    end
    render :update do |page|
      page.replace_html("exams", :partial => "exam_list", :id=> @exam_group) 
    end
         
  end
  
  def exam_update
    @exam_group=ExamGroup.find(params[:id])
    if params[:exam]
      Exam.update(params[:exam].keys, params[:exam].values)
    end
    if params[:cb]
      exams_marked_for_deletion=Exam.find(params[:cb].keys)
      Exam.destroy(exams_marked_for_deletion)
    end
    @exams=@exam_group.exams
    @school=@exam_group.klass.school
    @subjects=Subject.find(:all)
    flash[:notice] = 'Exam Details were successfully updated.'
    redirect_to(:controller => :schools, :action => 'exam_groups_index', :id=>@school, :exam_group => @exam_group)
  end
  
  def add_exam_dialog_show
    @exam_group=ExamGroup.find(params[:id])
    @subjects=Subject.find(:all)
  end
  
  def add_exam
    @exam_group=ExamGroup.find(params[:id])
    exam=Exam.new()
    exam.subject=Subject.find(params[:subject])
    exam.start_time=params[:start_time]
    exam.end_time=params[:end_time]
    exam.venue=params[:venue]
    exam.max_score=params[:max_score]
    exam.pass_score=params[:pass_score]
    @exam_group.exams << exam
    @exam_group.save!
    @exams=@exam_group.exams
    if @exam_group.exams.count==1
      render :update do |page|
        page << "jQuery('#dialog_add_exam').dialog('close');"
        page.replace_html("exams_index_div", :partial =>'exams', :object => @exams)
      end
    else
      render :update do |page|
        page << "jQuery('#dialog_add_exam').dialog('close');"
        page.insert_html(:bottom, "exam_list_table", :partial =>'exam', :object => exam)
      end
    end    
  rescue Exception => e
    flash[:notice]="Error occured in exam add: <br /> #{e.message}"
  end
  
  def self.tabs(school_id)
    user_id=School.find(school_id).user.id
    tabs = [:Home => {:controller => :schools, :action => 'show', :id=>school_id},
    :Classes => {:controller => :schools, :action => 'klasses', :id=>school_id},
    :Teachers => {:controller => :schools, :action => 'teachers_index', :id=>school_id},
    :Students => {:controller => :schools, :action => 'students_list', :id=>school_id},
    :Departments => '#',
    :Exams => {:controller => :schools, :action => 'exam_groups_index', :id=>school_id},
    :Profile =>  {:controller => :user_profiles, :action => 'show', :id=>user_id} ]
    return tabs
  end
  
end
