# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  layout 'schoolarly'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  
  #before_filter :require_user
  
  def set_active_user(user_id)
    session[:active_user] = user_id
  end
  
  def active_user
    begin
      return User.find(session[:active_user])
    rescue Exception => err
      return nil
    end
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def navigation_tabs
    if(active_user)
      return eval("#{active_user.person_type.pluralize}Controller").send(:tabs , active_user.person_id)
    end
  end
  
  def allow_read(object)
    current_user and (current_user.is_reader_of?(object) or current_user.is_reader_of?(object.class))
  end
  
  def allow_write(object)
    current_user and (current_user.is_editor_of?(object) or current_user.is_editor_of?(object.class))
  end
  
  def add_breadcrumb(name, url = nil)
    @breadcrumbs ||= []
    @breadcrumbs << [name, url]
  end
  
  def add_page_action(*options)
    @page_actions ||=[]
    @page_actions << [*options]
  end
  
  def add_details(options)
    @details = options
  end
  
  def add_js_page_action(options)    
    @js_page_actions ||=[]
    @js_page_actions << options
  end
  
  def render_failure(args)
    render :update do |page|
      page.refresh_dialog args[:refresh]
    end
  end
  
  
  # :object or :collection
  # :insert or :replace or :delete
  # (optional, default - true) :close_modal_box => false
  # {optional, default - true} :open_tab => false
  #
  
  def render_success(args)
    args[:close_modal_box] = true if args[:close_modal_box].nil? 
    args[:open_tab] = true if args[:open_tab].nil?
    collection = args[:collection]
    collection ||= []
    if(args[:object])
      collection << args[:object]      
    end
    render(:update) do |page|
      page.close_dialog if args[:close_modal_box]
      page.open_tab collection.first if args[:open_tab]
      collection.each do |obj|     
        if(args[:insert])          
          page.insert_object  obj, args[:insert]
        end
        if(args[:replace])
          page.replace_object obj, args[:replace]
        end
        if(args[:delete])          
          page.remove_object obj
        end
      end      
      yield page if block_given?      
    end
  end
  
  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page - "+request.request_uri
      redirect_to new_user_session_url
      return false
    end
  end
  
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  #Exception Handlers
  
  #  rescue_from Exception do |exception|
  #    case  exception
  #      when ActiveRecord::RecordNotFound 
  #        then flash_and_redirect_back(exception)
  #      when ActiveRecord::StatementInvalid 
  #        then flash_and_redirect_back(exception)
  #      when ActiveRecord::RecordInvalid 
  #        then flash_and_redirect_back(exception)
  #    else
  #      flash_and_redirect_back(exception)
  #    end
  #  end
  #  
  #  def flash_and_redirect_back(exception)
  #    flash[:notice]="Error Occurred: <br /> #{exception.message}"
  #    redirect_to(session[:parent_url] ? session[:parent_url] : request.request_uri)
  #  end
  
  def get_users_for_composing(person)
    # TODO if user == current_user 
    school =  person.is_a?(School) ? person : person.school
    if school
      users = User.find_all_by_person_type_and_person_id('Teacher',school.teacher_ids) 
      users << User.find_all_by_person_type_and_person_id('Student',school.student_ids)
      #TODO parents
      #  	parent_ids = person.school.students.collect do |student|
      #   	student.parent.id
      #  	end
      #  	users << User.find_all_by_person_type_and_person_id('Parent',parent_ids)
    end
    return users
    # end
  end
  
#  def get_dialog_content(args)
#    collection = args[:collection]
#    message = get_message_text(args[:message]) || 'No action allowed'
#    render = args[:render]
#    return (collection.empty? || render.nil?) ? {:text =>'<blockquote>' + message + '</blockquote>'} : render
#  end
#  
#  def get_message_text(message)
#    case message
#      when :message_if_empty_unallotted_papers then 'No more papers to add' 
#      when :message_if_empty_papers then 'No paper available'
#      else message
#    end
#  end
  
end
