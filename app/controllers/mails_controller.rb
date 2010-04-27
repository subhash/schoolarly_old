class MailsController < ApplicationController
   
  def new
    @users = current_user.person.school.users
  end
  
  def create
    sender=current_user
    @user= params[:receiver].nil? ? current_user : User.find(params[:receiver])
    receivers = [User.find(params[:receiver] || params[:mail][:user_ids].compact.reject(&:blank?))].flatten
    raise if receivers.empty? || params[:message][:body].blank?
    Mail.transaction do
        sentMail=sender.send_message(receivers, *params[:message].values)
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
    @user=@mail.user
    Mail.transaction do
      @sentMail=@user.reply_to_sender(@mail, params[:body], params[:subject])
    end
    render :template => 'mails/create_success'
  rescue Exception => e
    flash.now[:notice] = 'Error occured during posting. Try again...'
    render :template => 'mails/send_reply_error'
  end
  
  def show
    @mail=Mail.find(params[:id])
    @mail.mark_as_read()
  end
  
  def destroy
    @mail=Mail.find(params[:id])
    @mail.user.mailbox.move_to(:trash, :conditions => 'id = ' + @mail.id.to_s) unless @mail.trashed
    Mail.delete(@mail) if @mail.trashed
  end
  
end
