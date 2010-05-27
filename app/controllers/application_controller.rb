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
  
  def add_details(options)
    @details = options
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

  rescue_from Exception, :with => :notify_me
  rescue_from ActiveRecord::RecordNotFound, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors
  rescue_from ActiveRecord::StatementInvalid, :with => :show_errors
  rescue_from NoMethodError, :with => :show_errors
  
  protected
  
  def notify_me
    Exceptional.rescue do
      raise
    end
  end
  
  def show_errors(exception)
    render :text => exception.message
  end
  
end
