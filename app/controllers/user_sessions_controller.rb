class UserSessionsController < ApplicationController
  skip_before_filter :require_user, :except => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!" 
      render :update do |page|
        page.close_dialog
        page.redirect_to current_user.person
      end      
    else
      render :action => :new
    end
  end
  
  def destroy    
    destroyed = current_user_session.destroy
    respond_to do |wants|
      wants.js {
        render :update do |page|
          if(destroyed)
            flash[:notice] = "Logout successful!"
            page.refresh
          else
            page.error_dialog 'Error! Could not logout'
          end
        end
      }
      wants.html {
        if(destroyed)
          flash[:notice] = "Logout successful!"
          redirect_to :root
        else
          flash[:notice] = "Logout successful!"
          redirect_to request.request_uri
        end
      }
    end
  end
  
end
