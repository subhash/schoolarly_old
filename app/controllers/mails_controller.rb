class MailsController < ApplicationController

  def create
    sender=current_user
    @message = Message.new(params[:message])
    @mail = Mail.find(params[:mail]) if params[:mail]
    receivers = User.find(params[:message][:recipient_ids]) if params[:message][:recipient_ids]
    @selected_user_ids = params[:message][:recipient_ids] if params[:message][:recipient_ids]
    selected_users = User.with_permissions_to(:contact) & @mail.conversation.users if params[:mail]
    @users = !selected_users.nil? ? selected_users : User.with_permissions_to(:contact)
    template_name = 'mails/create_success'
    if @message.valid?
      Mail.transaction do 
        sender.send_message(receivers, params[:message][:body], params[:message][:subject]) unless @mail
        sender.reply(@mail.conversation, receivers, params[:message][:body], params[:message][:subject]) if @mail
        flash[:notice] = 'Message successfully posted'
      end
    else
      template_name = 'mails/create_failure'
    end
    render :template => template_name
  rescue Exception => e
    flash[:notice] = 'Error occurred during posting. Please try again...'
    render :template => 'mails/create_failure'
  end
  
  def new
    @message=Message.new()
    @mail = Mail.find(params[:id]) if params[:id]
    selected_users = User.with_permissions_to(:contact) & @mail.conversation.users if params[:id]
    @selected_user_ids = selected_users.collect{|u| u.id} if params[:id]
    @users = !selected_users.nil? ? selected_users : User.with_permissions_to(:contact)
  end
  
  def destroy
    @mail=Mail.find(params[:id])
    @user = @mail.user
    @user.mailbox.move_to(:trash, :conditions => 'id = ' + @mail.id.to_s) unless @mail.trashed
    Mail.delete(@mail) if @mail.trashed
  end
  
end
