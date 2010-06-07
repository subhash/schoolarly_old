class MailsController < ApplicationController
   
  def create
    sender=current_user
    @mail = Mail.find(params[:mail]) if params[:mail]
    receivers = User.find(params[:user_ids])
    raise if receivers.empty? || params[:body].blank?
    Mail.transaction do
      sender.send_message(receivers, params[:body], params[:subject]) unless @mail
      sender.reply(@mail.conversation, receivers, params[:body], params[:subject]) if @mail
    end
    render :template => 'mails/create_success'
  rescue Exception => e
    flash.now[:notice] = e.message + 'Error occurred during posting. Try again...'
    render :template => 'mails/create_failure'  
  end
  
  def new
    @mail = Mail.find(params[:id]) if params[:id]
    selected_users = @mail.conversation.users if params[:id]
    @selected_user_ids = selected_users.collect{|u| u.id} if params[:id]
    @users = !selected_users.nil? ? selected_users : current_user.person.is_a?(SchoolarlyAdmin) ? User.all : (!current_user.person.school.nil? ? current_user.person.school.users : [])
  end
  
  def destroy
    @mail=Mail.find(params[:id])
    @user = @mail.user
    @user.mailbox.move_to(:trash, :conditions => 'id = ' + @mail.id.to_s) unless @mail.trashed
    Mail.delete(@mail) if @mail.trashed
  end
  
end
