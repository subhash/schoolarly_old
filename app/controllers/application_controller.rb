# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  layout 'schoolarly'
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  
  before_filter :require_user
  
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
  
end
