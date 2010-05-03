class MailsController < ApplicationController
   
  def create
    sender=current_user
    @user = User.find(params[:user]) if params[:user]
    receivers = [User.find(params[:user_ids].compact.reject(&:blank?))].flatten
    raise if receivers.empty? || params[:body].blank?
    Mail.transaction do
        sentMail=sender.send_message(receivers, params[:body], params[:subject])
    end
    render :template => 'mails/create_success'
  rescue Exception => e
    flash.now[:notice] = e.message + 'Error occurred during posting. Try again...'
    render :template => 'mails/create_failure'  
  end
  
  def reply_new
    @mail=Mail.find(params[:id])
  end
  
  def send_reply
    @mail=Mail.find(params[:mail])
    receivers = [User.find(params[:user_ids].compact.reject(&:blank?))].flatten
    raise if receivers.empty? || params[:body].blank?
    Mail.transaction do
      @sentMail=@mail.user.reply(@mail.conversation, receivers, params[:body], params[:subject])
    end
    render :template => 'mails/create_success'
  rescue Exception => e
    flash.now[:notice] = 'Error occured during posting. Try again...'
    render :template => 'mails/send_reply_error'
  end
  
  def destroy
    @mail=Mail.find(params[:id])
    @user = @mail.user
    @user.mailbox.move_to(:trash, :conditions => 'id = ' + @mail.id.to_s) unless @mail.trashed
    Mail.delete(@mail) if @mail.trashed
  end
  
end
